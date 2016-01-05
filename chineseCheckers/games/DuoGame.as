package chineseCheckers.games
{
	import chineseCheckers.CellTypes;
	import chineseCheckers.Colors;
	import chineseCheckers.players.AbstractPlayer;
	import chineseCheckers.players.PlayerEvent;
	import chineseCheckers.display.AbstractDisplay;
	import chineseCheckers.display.Console;
	import chineseCheckers.grid.Grid;
	import chineseCheckers.grid.GridParser;
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class DuoGame extends EventDispatcher
	{
		
		private var _grid:Grid;
		private var _display:AbstractDisplay;
		private var _console:Console;
		
		private var _aCtrls:Array;
		private var _curCtrlIndex:uint;
		
		private var _goalPlayer0X:Array;
		private var _goalPlayer0Y:Array;
		private var _goalPlayer1X:Array;
		private var _goalPlayer1Y:Array;
		
		private var _timer:Timer;
		
		public function DuoGame()
		{
			_timer = new Timer(50, 0);
		}
		
		public function init( configGrid:String
							, display:AbstractDisplay
							, controler0:AbstractPlayer
							, controler1:AbstractPlayer
							, console:Console):void
		{
			_grid = GridParser.parse(configGrid);
			
			_display = display;
			
			_display.init( _grid.width, _grid.height);
			_display.updateGrid( _grid );
			
			_console = console;
			
			controler0.init(_grid, CellTypes.PLAYER0, _display, _console);
			controler1.init(_grid, CellTypes.PLAYER1, _display, _console);
			_aCtrls = [controler0, controler1];
			
			_goalPlayer0X = new Array();
			_goalPlayer0Y = new Array();
			_goalPlayer1X = new Array();
			_goalPlayer1Y = new Array();
			for ( var y:int=0 ; y<_grid.height ; y++ )
			{
				for ( var x:int=0 ; x<_grid.width ; x++ )
				{
					if ( _grid.getCell(x, y) == CellTypes.PLAYER0 )
					{
						_goalPlayer1X.push( x );
						_goalPlayer1Y.push( y );
					}
					else if ( _grid.getCell(x, y) == CellTypes.PLAYER1 )
					{
						_goalPlayer0X.push( x );
						_goalPlayer0Y.push( y );
					}
				}
			}
		}
		
		public function start():void
		{
			_curCtrlIndex = 0;
			goPlayer();
		}
		
		//
		
		private function goPlayer():void
		{
			_aCtrls[_curCtrlIndex].addEventListener(PlayerEvent.TURN_PLAYED, onPlayerTurn);
			
			
			trace( "-> GO  " + Colors.GET_COLOR( AbstractPlayer(_aCtrls[_curCtrlIndex]).cell ).toString(16) );
			AbstractPlayer(_aCtrls[_curCtrlIndex]).itsYourTurn();
		}
		
		private var _reachableX:Array = new Array();
		private var _reachableY:Array = new Array();
		private function onPlayerTurn(e:PlayerEvent):void
		{
			_reachableX.splice(0);
			_reachableY.splice(0);
			
			trace( "played: from", e.turn.fromCellX, e.turn.fromCellY, "- to", e.turn.toCellX, e.turn.toCellY );
			
			if ( _grid.getCell(e.turn.fromCellX, e.turn.fromCellY) != e.turn.controlerCell )
			{
				AbstractPlayer(_aCtrls[_curCtrlIndex]).turnRefused();
				trace( "ILLEGAL : the cell you pick doesn't belong to you." );
			}
			else
			{
				_grid.getReachable(    e.turn.fromCellX, e.turn.fromCellY
									, _reachableX, _reachableY, true );
				
				if ( _grid.contains( e.turn.toCellX, e.turn.toCellY
									, _reachableX, _reachableY ) )
				{
					trace( "Your turn is valid." );
					_grid.setCell( e.turn.fromCellX, e.turn.fromCellY, CellTypes.EMPTY );
					_grid.setCell( e.turn.toCellX, e.turn.toCellY, e.turn.controlerCell );
					_display.updateGrid( _grid );
					AbstractPlayer(_aCtrls[_curCtrlIndex]).turnValidated();
					_aCtrls[_curCtrlIndex].removeEventListener(PlayerEvent.TURN_PLAYED, onPlayerTurn);
					if ( checkWin( e.turn.controlerCell ) )
					{
						_console.addMessage( "- " + Colors.GET_PLAYER_COLOR_NAME(Colors.GET_COLOR(e.turn.controlerCell)) + " wins !" );
						_console.addMessage( "end of the game" );
					}
					else
					{
						_curCtrlIndex = (_curCtrlIndex + 1) % 2;
						_timer.reset();
						_timer.addEventListener(TimerEvent.TIMER, onTimerGoPlayer);
						_timer.start();
					}
				}
				else
				{
					AbstractPlayer(_aCtrls[_curCtrlIndex]).turnRefused();
					trace( "ILLEGAL : the cell destination is not reachable.");
				}
			}
		}
		
		private function onTimerGoPlayer(event:TimerEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER, onTimerGoPlayer);
			goPlayer();
		}
		
		private function checkWin( cell:uint ):Boolean
		{
			var goalCheckX:Array;
			var goalCheckY:Array;
			if ( cell == CellTypes.PLAYER0 )
			{
				goalCheckX = _goalPlayer0X;
				goalCheckY = _goalPlayer0Y;
			}
			else if ( cell == CellTypes.PLAYER1 )
			{
				goalCheckX = _goalPlayer1X;
				goalCheckY = _goalPlayer1Y;
			}
			
			var win:Boolean = true;
			for ( var i:int=0 ; i<goalCheckX.length ; i++ )
			{
				if ( _grid.getCell(goalCheckX[i], goalCheckY[i]) != cell )
				{
					win = false;
					break;
				}
			}
			
			return win;
		}
		
	}
}