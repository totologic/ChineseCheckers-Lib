package chineseCheckers.players
{
	import chineseCheckers.CellTypes;
	import chineseCheckers.display.AbstractDisplay;
	import chineseCheckers.display.Console;
	import chineseCheckers.gameTree.GameNode;
	import chineseCheckers.gameTree.GameTree;
	import chineseCheckers.grid.Grid;
	
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class AIPlayerMinMax extends AbstractPlayer
	{
		private var _me:AIPlayerDatas;
		private var _him:AIPlayerDatas;
		
		private var _copyGrid:Grid;
		
		private var _timer:Timer;
		
		public function AIPlayerMinMax()
		{
			super();
			
			_timer = new Timer( 100, 1 );
		}
		
		public function get me():AIPlayerDatas
		{
			return _me;
		}

		public override function init(grid:Grid
									, cellId:uint
									, display:AbstractDisplay
									, console:Console):void
		{
			super.init( grid, cellId, display, console );
			
			_me = new AIPlayerDatas();
			_me.init( grid, cellId );
			
			var cellHim:uint;
			if ( cellId == CellTypes.PLAYER0 )
				cellHim = CellTypes.PLAYER1;
			else
				cellHim = CellTypes.PLAYER0;
			_him = new AIPlayerDatas();
			_him.init( grid, cellHim );
			
			_copyGrid = new Grid( _grid.width, _grid.height );
		}
		
		public override function itsYourTurn():void
		{
			
			_console.addMessage( "- It is computer's turn" );
			_console.addMessage( "please wait a moment..." );
			
			_timer.reset();
			_timer.addEventListener(TimerEvent.TIMER, onTimerPlayTurn);
			_timer.delay = 50;
			_timer.start();
		}
		
		private const MAX_DEPTH:int = 2;
		private var _currentDepth:int;
		public var _gameTree:GameTree = new GameTree();
		private var _curNode:GameNode;
		private var _curGrid:Grid;
		private var _childNode:GameNode;
		private var _childGrid:Grid;
		private var _playerToPlay:AIPlayerDatas;
		private var _playerCellsX:Array;
		private var _playerCellsY:Array;
		private var _reachableX:Array = new Array();
		private var _reachableY:Array = new Array();
		private var _turn:Turn;
		private function onTimerPlayTurn(event:TimerEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER, onTimerPlayTurn);
			_timer.stop();
			
			var timeStart:int = getTimer();
			
			//// tree generation ////
			_gameTree.empty();
			_gameTree.root.value.grid = _grid;
			_gameTree.root.value.turn = null;
			_currentDepth = 0;
			var i:int;
			var j:int;
			while (_currentDepth < MAX_DEPTH)
			{
				_playerToPlay = ( _currentDepth % 2 == 0 ) ? _me : _him;
				_gameTree.beginNodeBrowsing(_currentDepth);
				while ( (_curNode = _gameTree.nextNode()) )
				{
					_curGrid = Grid(_curNode.value.grid);
					
					if ( winning( _curGrid, _playerToPlay ) )
						continue;
					
					_playerCellsX = _curGrid.aXByCellTypes[_playerToPlay.cell];
					_playerCellsY = _curGrid.aYByCellTypes[_playerToPlay.cell];
					for ( i=0 ; i<_playerToPlay.numCells ; i++ )
					{
						_reachableX.splice(0);
						_reachableY.splice(0);
						_curGrid.getReachable( _playerCellsX[i], _playerCellsY[i]
											, _reachableX, _reachableY, true );
						for ( j=0 ; j<_reachableX.length ; j++ )
						{
							_childNode = _curNode.addChild();
							_childNode.value.grid = _childGrid = new Grid(_curGrid.width, _curGrid.height);
							_childGrid.copyGrid( _curGrid );
							_childGrid.setCell( _playerCellsX[i], _playerCellsY[i], CellTypes.EMPTY);
							_childGrid.setCell( _reachableX[j], _reachableY[j], _playerToPlay.cell);
							_childNode.value.turn = new Turn( _playerToPlay.cell
															, _playerCellsX[i], _playerCellsY[i] 
															, _reachableX[j], _reachableY[j]    );
						}
					}
				}
				
				_currentDepth++;
			}
			
			// leaf nodes evaluation
			_currentDepth = MAX_DEPTH;
			_gameTree.beginNodeBrowsing(_currentDepth);
			while ( (_curNode = _gameTree.nextNode()) )
				_curNode.value.score = evaluateGrid(_curNode.value.grid as Grid);
			
			// cut the tree by min/max
			_currentDepth = MAX_DEPTH - 1;
			while (_currentDepth >= 0)
			{
				_gameTree.beginNodeBrowsing(_currentDepth);
				_playerToPlay = ( _currentDepth % 2 == 0 ) ? _me : _him;
				while ( (_curNode = _gameTree.nextNode()) )
				{
					_curNode.value.score = _curNode.children[_curNode.children.length-1].value.score;
					for ( i=_curNode.children.length-2 ; i>=0 ; i-- )
					{
						_childNode = _curNode.children[i];
						if ( _playerToPlay == _me )
						{
							if (_childNode.value.score < _curNode.value.score )
							{
								_curNode.value.score = _childNode.value.score;
								_curNode.children.splice(i+1, 1);
							}
							else
								_curNode.children.splice(i, 1);
						}
						else
						{
							if (_childNode.value.score > _curNode.value.score )
							{
								_curNode.value.score = _childNode.value.score;
								_curNode.children.splice(i+1, 1);
							}
							else
								_curNode.children.splice(i, 1);
						}
					}
				}
				_currentDepth--;
			}
			
			_turn = _gameTree.root.children[0].value.turn as Turn;
			_display.setSelected( _turn.fromCellX, _turn.fromCellY, true );
			_reachableX.splice(0);
			_reachableY.splice(0);
			_grid.getReachable( _turn.fromCellX, _turn.fromCellY, _reachableX, _reachableY, true );
			_display.highlight( _reachableX, _reachableY, _cell );
			
			_console.addMessage( "time elapsed: " + ((getTimer() - timeStart) / 1000) );
			
			_timer.reset();
			_timer.addEventListener(TimerEvent.TIMER, onPlayerChoosePawn);
			_timer.delay = 1500;
			_timer.start();
		}
		
		private function onPlayerChoosePawn(event:TimerEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER, onPlayerChoosePawn);
			_timer.stop();
			
			_display.updateGrid(_grid);
			
			dispatchEvent( new PlayerEvent( PlayerEvent.TURN_PLAYED, _turn ) );
		}
		
		public override function turnValidated():void
		{
			
		}
		
		public override function turnRefused():void
		{
			
		}
		
		//
		
		private var _adjX:Array = new Array();
		private var _adjY:Array = new Array();
		private function numIsolatedCells( grid:Grid ):uint
		{
			var iaCellsX:Array = _grid.aXByCellTypes[_cell];
			var iaCellsY:Array = _grid.aYByCellTypes[_cell];
			var count:uint = 0;
			for ( var i:int=0 ; i<iaCellsX.length ; i++ )
			{
				_adjX.splice(0);
				_adjY.splice(0);
				grid.getAdjacents(iaCellsX[i], iaCellsY[i]
								, _adjX, _adjY, false, true );
				if ( _adjX.length == 0 )
					count++;
			}
			return count;
		}
		
		private function winning( grid:Grid, player:AIPlayerDatas ):Boolean
		{
			var win:Boolean = true;
			for ( var i:int=0 ; i<player.goalCellsX.length ; i++ )
			{
				if ( grid.getCell(player.goalCellsX[i], player.goalCellsY[i]) != player.cell )
				{
					win = false;
					break;
				}
			}
			return win;
		}
		
		private var _evaluatedScore:Number;
		private var _otherPlayer:AIPlayerDatas;
		public function evaluateGrid( grid:Grid, tf:TextField=null ):Number
		{
			// symetric grid evaluation.
			// low value is good for me
			// high value is good for him
			
			if ( winning(grid, _me) )
			{
				_evaluatedScore = -999999;
				return _evaluatedScore;
			}
			
			if ( winning(grid, _him) )
			{
				_evaluatedScore = 999999;
				return _evaluatedScore;
			}
			
			_evaluatedScore = 0;
			
			_evaluatedScore += _me.getDistancesToGoal(grid.aXByCellTypes[_me.cell], grid.aYByCellTypes[_me.cell]);
			_evaluatedScore -= _him.getDistancesToGoal(grid.aXByCellTypes[_him.cell], grid.aYByCellTypes[_him.cell]);
			
			//_evaluatedScore += (grid.haveNeighbour(playerToPlay.farthestX, playerToPlay.farthestY, playerToPlay.cell)) ? 0 : 10;
			
			return _evaluatedScore;
		}
		
	}
}