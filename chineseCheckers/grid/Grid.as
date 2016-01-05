package chineseCheckers.grid
{
	import chineseCheckers.CellTypes;
	
	import flash.geom.Point;
	
	public class Grid
	{
		private var _width:uint;
		private var _height:uint;
		private var _array:Array;
		
		private var _aXByCellTypes:Array;
		private var _aYByCellTypes:Array;
		
		private const VERTICAL_DISTANCE:Number = Math.sin(Math.PI / 3);
		private const ODD_X_OFFSET:Number = 0.5;
		
		public function Grid( width:uint, height:uint )
		{
			_width = width;
			_height = height;
			_array = new Array();
			for ( var y:int=0 ; y<_height ; y++  )
			{
				_array[y] = new Array();
				for ( var x:int=0 ; x<_width ; x++ )
				{
					_array[y][x] = CellTypes.NONE;
				}
			}
		}
		
		public function get aYByCellTypes():Array	{	return _aYByCellTypes;	}
		public function get aXByCellTypes():Array	{	return _aXByCellTypes;	}
		public function get array():Array	{	return _array;	}

		public function init( aX:Array=null, aY:Array=null, aType:Array=null ):void
		{
			_aXByCellTypes = new Array();
			_aXByCellTypes.push(new Array());
			_aXByCellTypes.push(new Array());
			_aXByCellTypes.push(new Array());
			_aXByCellTypes.push(new Array());
			_aXByCellTypes.push(new Array());
			_aXByCellTypes.push(new Array());
			_aXByCellTypes.push(new Array());
			_aXByCellTypes.push(new Array());
			_aXByCellTypes.push(new Array());
			_aYByCellTypes = new Array();
			_aYByCellTypes.push(new Array());
			_aYByCellTypes.push(new Array());
			_aYByCellTypes.push(new Array());
			_aYByCellTypes.push(new Array());
			_aYByCellTypes.push(new Array());
			_aYByCellTypes.push(new Array());
			_aYByCellTypes.push(new Array());
			_aYByCellTypes.push(new Array());
			_aYByCellTypes.push(new Array());
			
			for ( var y:int=0 ; y<_height ; y++  )
			{
				for ( var x:int=0 ; x<_width ; x++ )
				{
					_array[y][x] = CellTypes.NONE;
				}
			}
			
			var i:int;
			if (aX && aY && aType)
			{
				for ( i=0 ; i<aX.length ; i++ )
				{
					_array[aY[i]][aX[i]] = aType[i];
					_aXByCellTypes[aType[i]].push( aX[i] );
					_aYByCellTypes[aType[i]].push( aY[i] );
				}
			}
		}
		
		public function get width():uint	{	return _width;	}
		public function get height():uint	{	return _height;	}
		
		public function getCell(x:int, y:int):uint
		{
			if ( x < 0 || x >= _width || y < 0 || y >= _height )
				return CellTypes.NONE;
			else
				return _array[y][x];
		}
		
		public function setCell(x:uint, y:uint, value:uint):void
		{
			var curValCell:int = _array[y][x];
			var aX:Array = _aXByCellTypes[curValCell];
			var aY:Array = _aYByCellTypes[curValCell];
			for ( var i:int=0 ; i<aX.length ; i++ )
			{
				if ( aX[i] == x && aY[i] == y )
				{
					aX.splice(i, 1);
					aY.splice(i, 1);
					break;
				}
			}
			
			_aXByCellTypes[value].push( x );
			_aYByCellTypes[value].push( y );
			
			_array[y][x] = value;
		}
		
		public function getCellCartesian(x:uint, y:uint, resPoint:Point=null):Point
		{
			if ( ! resPoint )
				resPoint = new Point();
			
			resPoint.x = x + ((y % 2 == 1) ? ODD_X_OFFSET : 0);
			resPoint.y = y * VERTICAL_DISTANCE;
			
			return resPoint;
		}
		
		private var _aOpenX:Array = new Array();
		private var _aOpenY:Array = new Array();
		private var _aTemp1X:Array = new Array();
		private var _aTemp1Y:Array = new Array();
		private var _aTemp2X:Array = new Array();
		private var _aTemp2Y:Array = new Array();
		public function getReachable( sourceX:int, sourceY:int
									, aResultsX:Array
									, aResultsY:Array
									, skipSource:Boolean=false):void
		{
			// we consider only the playable cells
			if ( getCell(sourceX, sourceY) != CellTypes.NONE )
			{
				// just empty working arrays from any previous call
				_aOpenX.splice(0);
				_aOpenY.splice(0);
				_aTemp1X.splice(0);
				_aTemp1Y.splice(0);
				_aTemp2X.splice(0);
				_aTemp2Y.splice(0);
				
				// we get the empty adjacent cells from the starting cell
				// and push it into the final result list
				getAdjacents( sourceX, sourceY
							, aResultsX, aResultsY
							, true, false );
				
				// let's init the iteration process
				// by pushing the starting cell into the open list
				_aOpenX.push(sourceX);
				_aOpenY.push(sourceY);
				var sourceIsSkipped:Boolean=false;
				// we iterate while we have cells in the open list
				while ( _aOpenX.length )
				{
					// we consider the first cell of the open list
					// and push his occuped adjacent cells
					// into the temp list
					getAdjacents( _aOpenX[0], _aOpenY[0]
								, _aTemp1X, _aTemp1Y
								, false, true );
					
					// we push the empty opposites cells through these
					// occuped adjacents cells (it's a jump) into a 2nd temp list,
					// while cleaning the 1st temp list
					while ( _aTemp1X.length )
					{
						getOpposites( _aOpenX[0], _aOpenY[0]
									, _aTemp1X.shift(), _aTemp1Y.shift()
									, _aTemp2X, _aTemp2Y
									, true, false );
					}
					
					// among the opposite cells previously found,
					// we consider only these that are
					// not already in the result list
					// nor in the open list
					substract( _aTemp2X, _aTemp2Y, aResultsX, aResultsY )
					substract( _aTemp2X, _aTemp2Y, _aOpenX, _aOpenY )
					
					// then concat the filtered lists at the open list
					// and empty the temp list
					_aOpenX = _aOpenX.concat( _aTemp2X );
					_aOpenY = _aOpenY.concat( _aTemp2Y );
					_aTemp2X.splice(0);
					_aTemp2Y.splice(0);
					
					// we remove the first cell of the open list
					// while pushing it into the result list
					if ( skipSource && ! sourceIsSkipped )
					{
						_aOpenX.shift();
						_aOpenY.shift();
						sourceIsSkipped = true;
					}
					else
					{
						aResultsX.push( _aOpenX.shift() );
						aResultsY.push( _aOpenY.shift() );
					}
				}
			}
		}
		
		private var _aAdjX:Array = new Array();
		private var _aAdjY:Array = new Array();
		public function getAdjacents( sourceX:int, sourceY:int
									, aResultsX:Array, aResultsY:Array
									, emptyOnly:Boolean=false
									, occupedOnly:Boolean=false):void
		{
			if ( getCell(sourceX, sourceY) != CellTypes.NONE )
			{
				var i:int;
				if ( (sourceY % 2) == 0 )
				{
					_aAdjX.push( sourceX - 1 );
					_aAdjY.push( sourceY - 1 );
					//
					_aAdjX.push( sourceX );
					_aAdjY.push( sourceY - 1 );
					//
					_aAdjX.push( sourceX - 1 );
					_aAdjY.push( sourceY );
					//
					_aAdjX.push( sourceX - 1 );
					_aAdjY.push( sourceY + 1 );
					//
					_aAdjX.push( sourceX );
					_aAdjY.push( sourceY + 1 );
					//
					_aAdjX.push( sourceX + 1 );
					_aAdjY.push( sourceY );
				}
				else
				{
					_aAdjX.push( sourceX + 1 );
					_aAdjY.push( sourceY + 1 );
					//
					_aAdjX.push( sourceX - 1 );
					_aAdjY.push( sourceY );
					//
					_aAdjX.push( sourceX );
					_aAdjY.push( sourceY - 1 );
					//
					_aAdjX.push( sourceX + 1 );
					_aAdjY.push( sourceY - 1 );
					//
					_aAdjX.push( sourceX );
					_aAdjY.push( sourceY + 1 );
					//
					_aAdjX.push( sourceX + 1 );
					_aAdjY.push( sourceY );
				}
				
				for ( i=0 ; i<_aAdjX.length ; i++ )
					{
						if (   (emptyOnly && empty(_aAdjX[i], _aAdjY[i]))
							|| (occupedOnly && occuped(_aAdjX[i], _aAdjY[i]))
							|| ( (! emptyOnly) && (! occupedOnly) && exist(_aAdjX[i], _aAdjY[i])) )
						{
							aResultsX.push( _aAdjX[i] );
							aResultsY.push( _aAdjY[i] );
						}
					}
					
				_aAdjX.splice(0);
				_aAdjY.splice(0);
			}
		}
		
		public function getOpposites( sourceX:int, sourceY:int
									, pivotX:int, pivotY:int
									, aResultsX:Array, aResultsY:Array
									, emptyOnly:Boolean=false
									, occupedOnly:Boolean=false):void
		{
			var oppX:uint;
			var oppY:uint;
			
			if ( (pivotY % 2) == 0 )
			{
				if ( (sourceX + 1) == pivotX && sourceY == pivotY )
				{
					oppX = pivotX + 1;
					oppY = pivotY;
				}
				else if ( (sourceX + 1) == pivotX && (sourceY + 1) == pivotY )
				{
					oppX = pivotX;
					oppY = pivotY + 1;
				}
				else if ( sourceX == pivotX && (sourceY + 1) == pivotY )
				{
					oppX = pivotX - 1;
					oppY = pivotY + 1;
				}
				else if ( (sourceX - 1) == pivotX && sourceY == pivotY )
				{
					oppX = pivotX - 1;
					oppY = pivotY;
				}
				
				else if ( sourceX == pivotX && (sourceY - 1) == pivotY )
				{
					oppX = pivotX - 1;
					oppY = pivotY - 1;
				}
				else if ( (sourceX + 1) == pivotX && (sourceY - 1) == pivotY )
				{
					oppX = pivotX;
					oppY = pivotY - 1;
				}
			}
			else
			{
				if ( (sourceX + 1) == pivotX && sourceY == pivotY )
				{
					oppX = pivotX + 1;
					oppY = pivotY;
				}
				else if ( sourceX == pivotX && (sourceY + 1) == pivotY )
				{
					oppX = pivotX + 1;
					oppY = pivotY + 1;
				}
				else if ( (sourceX - 1) == pivotX && (sourceY + 1) == pivotY )
				{
					oppX = pivotX;
					oppY = pivotY + 1;
				}
				else if ( (sourceX - 1) == pivotX && sourceY == pivotY )
				{
					oppX = pivotX - 1;
					oppY = pivotY;
				}
				else if ( (sourceX - 1) == pivotX && (sourceY - 1) == pivotY )
				{
					oppX = pivotX;
					oppY = pivotY - 1;
				}
				else if ( sourceX == pivotX && (sourceY - 1) == pivotY )
				{
					oppX = pivotX + 1;
					oppY = pivotY - 1;
				}
			}
			if (   (emptyOnly && empty(oppX, oppY))
				|| (occupedOnly && occuped(oppX, oppY))
				|| ( (! emptyOnly) && (! occupedOnly) && exist(oppX, oppY)) )
			{
				aResultsX.push(oppX);
				aResultsY.push(oppY);
			}
		}
		
		private var _exist:Boolean;
		public function exist(x:uint, y:uint):Boolean
		{
			_exist = true;
			if (   x < 0 || x >= _width
				|| y < 0 || y >= _height
				|| _array[y][x] == CellTypes.NONE)
			{
				_exist = false;
			}
			return _exist;
		}
		
		private var _empty:Boolean;
		public function empty(x:uint, y:uint):Boolean
		{
			_empty = true;
			if (   x < 0 || x >= _width
				|| y < 0 || y >= _height
				|| _array[y][x] != CellTypes.EMPTY)
			{
				_empty = false;
			}
			return _empty;
		}
		
		private var _occuped:Boolean;
		public function occuped(x:uint, y:uint):Boolean
		{
			_occuped = true;
			if (   x < 0 || x >= _width
				|| y < 0 || y >= _height
				|| _array[y][x] == CellTypes.NONE
				|| _array[y][x] == CellTypes.EMPTY )
			{
				_occuped = false;
			}
			return _occuped;
		}
		
		public function haveNeighbour(sourceX:uint, sourceY:uint, p_cell:uint):Boolean
		{
			var res:Boolean = false;
			if ( (sourceY % 2) == 0 )
			{
				if(_array[sourceY - 1][sourceX - 1] == p_cell)
					res = true;
				else if(_array[sourceY - 1][sourceX] == p_cell)
					res = true;
				else if(_array[sourceY][sourceX - 1] == p_cell)
					res = true;
				else if(_array[sourceY + 1][sourceX - 1] == p_cell)
					res = true;
				else if(_array[sourceY + 1][sourceX] == p_cell)
					res = true;
				else if(_array[sourceY][sourceX + 1] == p_cell)
					res = true;
			}
			else
			{
				if(_array[sourceY + 1][sourceX + 1] == p_cell)
					res = true;
				else if(_array[sourceY][sourceX - 1] == p_cell)
					res = true;
				else if(_array[sourceY - 1][sourceX] == p_cell)
					res = true;
				else if(_array[sourceY - 1][sourceX + 1] == p_cell)
					res = true;
				else if(_array[sourceY + 1][sourceX] == p_cell)
					res = true;
				else if(_array[sourceY][sourceX + 1] == p_cell)
					res = true;
			}
			return res;
		}
		
		public function copyGrid(gridSource:Grid):void
		{
			if ( gridSource.width != _width || gridSource.height != _height )
				throw new Error( "Size of grid and gridSource doesn't match." );
			
			var i:int;
			
			_array = new Array();
			for ( i=0 ; i<gridSource.array.length ; i++ )
			{
				_array[i] = gridSource.array[i].slice();
			}
			
			_aXByCellTypes= new Array();
			_aYByCellTypes= new Array();
			for ( i=0 ; i<gridSource.aXByCellTypes.length ; i++ )
			{
				_aXByCellTypes[i] = (gridSource.aXByCellTypes[i] as Array).slice();
				_aYByCellTypes[i] = (gridSource.aYByCellTypes[i] as Array).slice();
			}
		}
		
		public function contains( cellX:uint, cellY:uint
								, listX:Array, listY:Array):Boolean
		{
			var response:Boolean = false;
			for ( var i:int=0 ; i<listX.length ; i++ )
			{
				if ( listX[i] == cellX && listY[i] == cellY )
				{
					response = true;
					break;
				}
			}
			return response;
		}
		
		//
		
		private function substract(   aSourceX:Array, aSourceY:Array
									, aSubstractorX:Array, aSubstractorY:Array ):void
		{
			for ( var i:int=aSourceX.length-1 ; i>=0 ; i-- )
			{
				for ( var j:int=0 ; j<aSubstractorX.length ; j++ )
				{
					if (   aSourceX[i] == aSubstractorX[j]
						&& aSourceY[i] == aSubstractorY[j] )
					{
						aSourceX.splice(i, 1);
						aSourceY.splice(i, 1);
						break;
					}
				}
			}
		}
		

	}
}