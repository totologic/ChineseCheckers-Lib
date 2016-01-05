package chineseCheckers.display
{
	import flash.events.Event;
	
	public class CellInteractionEvent extends Event
	{
		
		public static const CELL_CLICK:String = "cellClick";
		
		private var _cellX:uint;
		private var _cellY:uint;
		
		public function CellInteractionEvent( type:String, cellX:uint, cellY:uint )
		{
			super( type );
			_cellX = cellX;
			_cellY = cellY;
		}
		
		public function get cellX():uint	{	return _cellX;	}
		public function get cellY():uint	{	return _cellY;	}
		
		public override function clone():Event
		{
			return new CellInteractionEvent( this.type, _cellX, _cellY );
		}
		
	}
}