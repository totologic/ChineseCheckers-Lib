package chineseCheckers.display
{
	import chineseCheckers.grid.Grid;
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	
	[Event( name="cellClick", type="chineseCheckers.display.CellInteractionEvent" )]
	public class AbstractDisplay extends EventDispatcher
	{
		protected var _width:uint;
		protected var _height:uint;
		
		protected var _content:Sprite;
		
		public function AbstractDisplay()
		{
			
		}
		
		public function get width():uint	{	return _width;	}
		public function get height():uint	{	return _height;	}
		public function get content():Sprite	{	return _content;	}
		
		public function init( width:uint, height:uint ):void
		{
			_width = width;
			_height = height;
		}
		
		public function updateGrid( grid:Grid ):void
		{
			
		}
		
		public function setSelected(x:int, y:int, value:Boolean):void
		{
			
		}
		
		public function highlight(aX:Array, aY:Array, cell:uint):void
		{
			
		}
		
		public function clear():void
		{
			
		}

	}
}