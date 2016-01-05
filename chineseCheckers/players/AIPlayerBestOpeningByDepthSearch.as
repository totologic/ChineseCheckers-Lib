package chineseCheckers.players
{
	import chineseCheckers.CellTypes;
	import chineseCheckers.display.AbstractDisplay;
	import chineseCheckers.display.Console;
	import chineseCheckers.gameTree.GameNode;
	import chineseCheckers.gameTree.GameTree;
	import chineseCheckers.grid.Grid;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import chineseCheckers.StageInstance;
	
	public class AIPlayerBestOpeningByDepthSearch extends AbstractPlayer
	{
		private var _me:AIPlayerDatas;
		private var _him:AIPlayerDatas;
		
		public var _gameTree:GameTree = new GameTree();
		private var _copyGrid:Grid;
		private var _turn:Turn;
		
		private var _timer:Timer;
		private var _timeStart:int;
		
		public function AIPlayerBestOpeningByDepthSearch()
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
			
			var cellMe:uint = cell;
			_me = new AIPlayerDatas();
			_me.init( grid, cellMe );
			
			var cellHim:uint;
			if ( cellMe == CellTypes.PLAYER0 )
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
			_console.addMessage( "depth search at: " + MAX_DEPTH);
			_timeStart = getTimer();
			
			_timer.reset();
			_timer.addEventListener(TimerEvent.TIMER, buildTreeOrPlay);
			_timer.delay = 50;
			_timer.start();
		}
		
		
		private var _numTurn:int = 0;
		private var _aTurns:Array = new Array();
		
		private const MAX_DEPTH:int = 5;
		private var _currentDepth:int;
		private var _bestNode:GameNode;
		private var _bestScore:int;
		private var _curScore:Number;
		private var _curNode:GameNode;
		private var _curGrid:Grid;
		private var _otherNode:GameNode;
		private var _childNode:GameNode;
		private var _childGrid:Grid;
		private var _parentNode:GameNode;
		private var _parentBisNode:GameNode;
		private var _playerToPlay:AIPlayerDatas;
		private var _playerCellsX:Array;
		private var _playerCellsY:Array;
		private var _reachableX:Array = new Array();
		private var _reachableY:Array = new Array();
		private var __i:int;
		private var __j:int;
		
		private function buildTreeOrPlay(event:TimerEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER, buildTreeOrPlay);
			_timer.stop();
			
			if ( _numTurn == 0 )
			{
				//// tree generation ////
				_playerToPlay = _me;
				_gameTree.empty();
				_gameTree.root.value.grid = _grid;
								
				_currentDepth = 0;
				_bestNode = null;
				_bestScore = Number.POSITIVE_INFINITY;
				_curNode = _gameTree.root;
				_curNode.value.grid = _grid;
				_curNode.value.aTurns = null;
				
				StageInstance.STAGE.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			else
			{
				playTurn();
			}
		}
		
		
		private const STEPS_BY_FRAME:int = 250;
		private var _curStep:int;
		private function onEnterFrame(event:Event):void
		{
			_curStep = 0;
			while ( _curStep < STEPS_BY_FRAME )
			{
				_curStep++;
				
				if ( ! (_currentDepth == 0 && _curNode.value.aTurns && _curNode.value.aTurns.length == 0) )
				{
					if ( _currentDepth < MAX_DEPTH )
					{
						if ( _curNode.value.aTurns == null )
						{
							_curGrid = _curNode.value.grid;
							_curNode.value.aTurns = new Array();
							_playerCellsX = _curGrid.aXByCellTypes[_playerToPlay.cell];
							_playerCellsY = _curGrid.aYByCellTypes[_playerToPlay.cell];
							for ( __i=0 ; __i<_playerCellsX.length ; __i++ )
							{
								_reachableX.splice(0);
								_reachableY.splice(0);
								_curGrid.getReachable( _playerCellsX[__i], _playerCellsY[__i]
									, _reachableX, _reachableY, true );
								for ( __j=0 ; __j<_reachableX.length ; __j++ )
								{
									_curNode.value.aTurns.push( new Turn( _playerToPlay.cell
										, _playerCellsX[__i], _playerCellsY[__i]
										, _reachableX[__j], _reachableY[__j] ) );
								}
							}
						}
						else if ( _curNode.value.aTurns.length == 0 )
						{
							_curNode = _curNode.parent;
							_currentDepth--;
						}
						else
						{
							if ( _currentDepth == 0 )
							{
								_console.addMessage( "remaining branchs: " + _curNode.value.aTurns.length);
							}
							if ( _currentDepth == 1 )
							{
								_console.addMessage( "remaining sub branchs: " + _curNode.value.aTurns.length);
							}
							
							_turn = _curNode.value.aTurns.pop();
							_childNode = _curNode.addChild();
							_childNode.value.grid = _childGrid = new Grid(_curGrid.width, _curGrid.height);
							_childGrid.copyGrid( _curNode.value.grid );
							_childGrid.setCell( _turn.fromCellX, _turn.fromCellY, CellTypes.EMPTY);
							_childGrid.setCell( _turn.toCellX, _turn.toCellY, _playerToPlay.cell);
							_childNode.value.turn = _turn;
							_curNode = _childNode;
							_currentDepth++;
						}
					}
					else
					{
						_curScore = evaluateGrid( _curNode.value.grid, _playerToPlay );
						if ( _bestNode == null || _curScore < _bestScore )
						{
							if ( _bestNode )
							{
								_parentNode = _curNode;
								_parentBisNode = _bestNode;
								while ( _parentNode != _parentBisNode )
								{
									_parentNode = _parentNode.parent;
									_otherNode = _parentBisNode;
									_parentBisNode = _parentBisNode.parent;
								}
								_parentBisNode.removeChild( _otherNode, true);
								_otherNode = null;
							}
							
							_bestNode = _curNode;
							_bestScore = _curScore;
							_curNode = _curNode.parent;
							_currentDepth--;
						}
						else
						{
							_parentNode = _curNode;
							_parentBisNode = _bestNode;
							while ( _parentNode != _parentBisNode )
							{
								_otherNode = _parentNode;
								_parentNode = _parentNode.parent;
								_parentBisNode = _parentBisNode.parent;
								_currentDepth--;
								if ( _parentNode.value.aTurns.length > 0 )
									break;
							}
							_parentNode.removeChild( _otherNode, true );
							_otherNode = null;
							_curNode = _parentNode;
						}
					}
				}
				else
				{
					_gameTree.beginNodeBrowsing(MAX_DEPTH);
					_parentNode = _gameTree.nextNode();
					var indexTurn:int = MAX_DEPTH-1;
					while ( _parentNode != _gameTree.root )
					{
						_aTurns[indexTurn] = _parentNode.value.turn as Turn;
						_parentNode = _parentNode.parent;
						indexTurn--;
					}
					
					StageInstance.STAGE.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					playTurn();
					break;
				}
			}
		}
		
		private function playTurn():void
		{	
			if ( _numTurn >= _aTurns.length )
			{
				_console.addMessage( "AI can't play now");
				return;
			}
			
			_turn = _aTurns[_numTurn];
			_display.setSelected( _turn.fromCellX, _turn.fromCellY, true );
			_reachableX.splice(0);
			_reachableY.splice(0);
			_grid.getReachable( _turn.fromCellX, _turn.fromCellY, _reachableX, _reachableY, true );
			_display.highlight( _reachableX, _reachableY, _cell );
			
			_console.addMessage( "AI played in: " + ((getTimer() - _timeStart) / 1000) + "secs");
			
			_numTurn++;
			
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
			
			dispatchEvent( new PlayerEvent( PlayerEvent.TURN_PLAYED, _turn) );
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
		
		
		private const BEST_SUM_DISTANCES:String = "bestSumDistances";
		private const BEST_SINGLE_DISTANCE:String = "bestSingleDistance";
		
		private const evaluationMethod:String = BEST_SUM_DISTANCES;
		
		public function evaluateGrid( grid:Grid, playerToPlay:AIPlayerDatas, tf:TextField=null ):Number
		{
			_evaluatedScore = 0;
			
			switch ( evaluationMethod )
			{
				case BEST_SUM_DISTANCES :
					_evaluatedScore += playerToPlay.getDistancesToGoal( grid.aXByCellTypes[playerToPlay.cell]
																		, grid.aYByCellTypes[playerToPlay.cell] );
				break;
				//
				case BEST_SINGLE_DISTANCE :
					var bestScore:Number = 999999999;
					var curScore:Number;
					for ( var i:int=0 ; i<playerToPlay.numCells ; i++ )
					{
						curScore = playerToPlay.getSingleDistanceToGoal( grid.aXByCellTypes[playerToPlay.cell][i]
																		, grid.aYByCellTypes[playerToPlay.cell][i] );
						if ( curScore < bestScore )
							bestScore = curScore;
					}
					_evaluatedScore = bestScore;
				break;
				//
			}
			
			
			//_evaluatedScore += (grid.haveNeighbour(playerToPlay.farthestX, playerToPlay.farthestY, playerToPlay.cell)) ? 0 : 10;
			
			return _evaluatedScore;
		}
		
	}
}