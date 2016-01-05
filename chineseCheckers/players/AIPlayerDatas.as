package chineseCheckers.players
{
	import chineseCheckers.CellTypes;
	import chineseCheckers.grid.Grid;
	
	import flash.geom.Point;

	public class AIPlayerDatas
	{
		private var _cell:uint;
		private var _numCells:int;
		private var _goalCellsX:Array;
		private var _goalCellsY:Array;
		
		private var _averageStart:Point;
		private var _averageGoal:Point;
		private var _normalWhereToGo:Point;
		
		private var _aDistances:Array;
		
		public function AIPlayerDatas()
		{
			
		}
		
		public function get cell():uint	{	return _cell;	}
		public function get numCells():int	{	return _numCells;	}
		public function get normalWhereToGo():Point	{	return _normalWhereToGo;	}
		public function get averageGoal():Point	{	return _averageGoal;	}
		public function get averageStart():Point	{	return _averageStart;	}
		public function get goalCellsY():Array	{	return _goalCellsY;	}

		public function get goalCellsX():Array
		{
			return _goalCellsX;
		}

		public function init( grid:Grid, p_cell:uint ):void
		{
			_cell = p_cell;
			_numCells = grid.aXByCellTypes[_cell].length;
			
			_goalCellsX = new Array();
			_goalCellsY = new Array();
			
			for ( var y:int=0 ; y<grid.height ; y++ )
			{
				for ( var x:int=0 ; x<grid.width ; x++ )
				{
					if ( grid.getCell(x, y) != _cell	
						&&	(  grid.getCell(x, y) == CellTypes.PLAYER0
							|| grid.getCell(x, y) == CellTypes.PLAYER1 ) )
					{
						_goalCellsX.push( x );
						_goalCellsY.push( y );
					}
				}
			}
			
			_averageStart = new Point();
			_averageGoal = new Point();
			var resPoint:Point = new Point();
			var i:int;
			var j:int;
			for ( i=0 ; i<grid.aXByCellTypes[_cell].length ; i++ )
			{
				grid.getCellCartesian( grid.aXByCellTypes[cell][i], grid.aYByCellTypes[cell][i], resPoint );
				_averageStart.x += resPoint.x;
				_averageStart.y += resPoint.y;
			}
			_averageStart.x /= grid.aXByCellTypes[cell].length;
			_averageStart.y /= grid.aYByCellTypes[cell].length;
			for ( i=0 ; i<_goalCellsX.length ; i++ )
			{
				grid.getCellCartesian( _goalCellsX[i], _goalCellsY[i], resPoint );
				_averageGoal.x += resPoint.x;
				_averageGoal.y += resPoint.y;
			}
			_averageGoal.x /= _goalCellsX.length;
			_averageGoal.y /= _goalCellsY.length;
			
			_normalWhereToGo = new Point( _averageGoal.x - _averageStart.x, _averageGoal.y - _averageStart.y );
			_normalWhereToGo.normalize(1);
			
			_aDistances = new Array();
			for ( i=0 ; i<grid.height ; i++ )
			{
				_aDistances[i] = new Array();
				for ( j=0 ; j<grid.width ; j++ )
				{
					if ( grid.getCell(j, i) != CellTypes.NONE )
					{
						grid.getCellCartesian(j, i, resPoint);
						resPoint.x -= _averageGoal.x;
						resPoint.y -= _averageGoal.y;
						_aDistances[i][j] = resPoint.length;
					}
					else
					{
						_aDistances[i][j] = -1;
					}
				}
			}
		}
		
		public function getSingleDistanceToGoal( x:int, y:int ):Number
		{
			return _aDistances[y][x];
		}
		
		private var _maxDist:Number;
		private var _farthestX:int;
		private var _farthestY:int;
		public function getDistancesToGoal( aX:Array, aY:Array ):Number
		{
			_maxDist = -1;
			var distance:Number;
			var sum:Number = 0;
			var l:int = aX.length;
			for ( var i:int=0 ; i<l ; i++ )
			{
				distance = _aDistances[aY[i]][aX[i]];
				sum += distance;
				if ( distance > _maxDist )
				{
					_maxDist = distance;
					_farthestX = aX[i];
					_farthestY = aY[i];
				}
			}
			return sum;
		}
		
		public function get farthestX():int {	return _farthestX;	}
		public function get farthestY():int {	return _farthestY;	}
		
	}
}