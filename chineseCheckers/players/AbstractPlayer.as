package chineseCheckers.players
{
	import chineseCheckers.display.AbstractDisplay;
	import chineseCheckers.display.Console;
	import chineseCheckers.grid.Grid;
	
	import flash.events.EventDispatcher;
	
	[Event( name="turnPlayed", type="chineseCheckers.players.PlayerEvent" )]
	public class AbstractPlayer extends EventDispatcher
	{
		
		protected var _grid:Grid;
		protected var _cell:uint;
		protected var _display:AbstractDisplay;
		protected var _console:Console;
		
		public function AbstractPlayer()
		{
			
		}
		
		public function init( grid:Grid
							, cell:uint
							, display:AbstractDisplay
							, console:Console ):void
		{
			_grid = grid;
			_cell = cell;
			_display = display;
			_console = console;
		}
		
		public function get cell():uint		{	return _cell;	}
		
		public function itsYourTurn():void
		{
			
		}
		
		public function turnValidated():void
		{
			
		}
		
		public function turnRefused():void
		{
			
		}

	}
}