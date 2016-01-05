package chineseCheckers.display
{
	import flash.display.Sprite;
	
	public class AbstractCell extends Sprite
	{
		
		protected var _cellDataX:uint;
		protected var _cellDataY:uint;
		
		protected var _color:uint;
		
		public function AbstractCell()
		{
			
		}
		
		
		public function get color():uint	{	return _color;	}
		
		public function set color(value:uint):void
		{
			
		}
		
		public function selectIt( value:Boolean ):void
		{
			
		}
		
		public function highlightIt( color:uint ):void
		{
			
		}
		
		public function get cellDataX():uint	{	return _cellDataX;	}
		public function get cellDataY():uint	{	return _cellDataY;	}
		
	}
}