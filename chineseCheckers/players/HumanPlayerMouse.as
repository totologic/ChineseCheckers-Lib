package chineseCheckers.players
{
	import chineseCheckers.Colors;
	import chineseCheckers.display.AbstractDisplay;
	import chineseCheckers.display.CellInteractionEvent;
	import chineseCheckers.display.Console;
	import chineseCheckers.grid.Grid;
	
	import flash.events.MouseEvent;
	
	public class HumanPlayerMouse extends AbstractPlayer
	{
		
		private var _fromCellX:int;
		private var _fromCellY:int;
		private var _toCellX:int;
		private var _toCellY:int;
		
		public function HumanPlayerMouse()
		{
			
		}
		
		public override function init(grid:Grid
									, cellId:uint
									, display:AbstractDisplay
									, console:Console):void
		{
			super.init( grid, cellId, display, console );
		}
		
		public override function itsYourTurn():void
		{
			_console.addMessage( "- It is your turn" );
			_console.addMessage( "play one of your "  + Colors.GET_PLAYER_COLOR_NAME(Colors.GET_COLOR(_cell)) +  " pawn" );
			_fromCellX = -1;
			_fromCellY = -1;
			_toCellX = -1;
			_toCellY = -1;
			_display.addEventListener(CellInteractionEvent.CELL_CLICK, onClick);
		}
		
		public override function turnValidated():void
		{
			_display.removeEventListener(CellInteractionEvent.CELL_CLICK, onClick);
			_fromCellX = -1;
			_fromCellY = -1;
			_toCellX = -1;
			_toCellY = -1;
		}
		
		public override function turnRefused():void
		{
			_fromCellX = -1;
			_fromCellY = -1;
			_toCellX = -1;
			_toCellY = -1;
		}
		
		//
		
		private var __aReachableX:Array = new Array();
		private var __aReachableY:Array = new Array();
		private function onClick(e:CellInteractionEvent):void
		{
			if ( _fromCellX == -1 && _fromCellY == -1 )
			{
				if ( _grid.getCell(e.cellX, e.cellY) == _cell )
				{
					_fromCellX = e.cellX;
					_fromCellY = e.cellY;
					_display.setSelected( _fromCellX, _fromCellY, true);
					__aReachableX.splice(0);
					__aReachableY.splice(0);
					_grid.getReachable( _fromCellX, _fromCellY, __aReachableX, __aReachableY, true );
					_display.highlight( __aReachableX, __aReachableY, _cell );
				}
				else
				{
					_display.updateGrid(_grid);
					_console.addMessage("- click one of your pawn");
				}
			}
			else
			{
				if ( _fromCellX == e.cellX && _fromCellY == e.cellY )
				{
					_fromCellX = -1;
					_fromCellY = -1;
					_display.updateGrid(_grid);
				}
				else if ( _grid.getCell(e.cellX, e.cellY) == _cell )
				{
					_display.updateGrid(_grid);
					_fromCellX = e.cellX;
					_fromCellY = e.cellY;
					_display.setSelected( _fromCellX, _fromCellY, true);
					__aReachableX.splice(0);
					__aReachableY.splice(0);
					_grid.getReachable( _fromCellX, _fromCellY, __aReachableX, __aReachableY, true );
					_display.highlight( __aReachableX, __aReachableY, _cell );
				}
				else
				{
					__aReachableX.splice(0);
					__aReachableY.splice(0);
					_grid.getReachable( _fromCellX, _fromCellY, __aReachableX, __aReachableY, true );
					if ( _grid.contains( e.cellX, e.cellY, __aReachableX, __aReachableY ) )
					{
						_display.updateGrid(_grid);
						_toCellX = e.cellX;
						_toCellY = e.cellY;
						var turn:Turn;
						turn = new Turn(_cell, _fromCellX, _fromCellY, _toCellX, _toCellY);
						dispatchEvent(new PlayerEvent(PlayerEvent.TURN_PLAYED, turn) );
					}
					else
					{
						_console.addMessage("- click one empty reachable position");
					}
				}
			}
		}

	}
}