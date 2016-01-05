package chineseCheckers.display
{
	import flash.display.Sprite;
	
	public class SimpleCell extends AbstractCell
	{
		public static const RADIUS:Number = 14;
		public static const WIDTH:Number = 2 * RADIUS * Math.cos( Math.PI / 6 );
		public static const HEIGHT:Number = 2 * RADIUS;
		public static const LENGTH_EDGE:Number = 2 * RADIUS * Math.sin( Math.PI / 6 );
		
		public function SimpleCell(cellDataX:uint, cellDataY:uint)
		{
			_cellDataX = cellDataX;
			_cellDataY = cellDataY;
			_color = NaN;
		}
		
		public override function set color(value:uint):void
		{
			_color = value;
			graphics.clear();
			graphics.moveTo(0, -RADIUS);
			graphics.lineStyle(1, 0x000000);
			graphics.beginFill(value);
			graphics.lineTo( RADIUS * Math.cos(-Math.PI / 6), RADIUS * Math.sin(-Math.PI / 6) );
			graphics.lineTo( RADIUS * Math.cos(Math.PI / 6), RADIUS * Math.sin(Math.PI / 6) );
			graphics.lineTo( 0, RADIUS);
			graphics.lineTo( RADIUS * Math.cos(Math.PI * 5 / 6), RADIUS * Math.sin(Math.PI * 5 / 6) );
			graphics.lineTo( RADIUS * Math.cos(Math.PI * 7 / 6), RADIUS * Math.sin(Math.PI * 7 / 6) );
			graphics.lineTo( 0, -RADIUS);
			graphics.endFill();
		}
		
		public override function selectIt( value:Boolean ):void
		{
			if ( ! value )
			{
				color = color;
			}
			else
			{
				var radius:Number = RADIUS * 0.9;
				graphics.moveTo(0, -radius);
				graphics.lineStyle(2, 0xFFFFFF, 1);
				graphics.lineTo( radius * Math.cos(-Math.PI / 6), radius * Math.sin(-Math.PI / 6) );
				graphics.lineTo( radius * Math.cos(Math.PI / 6), radius * Math.sin(Math.PI / 6) );
				graphics.lineTo( 0, radius);
				graphics.lineTo( radius * Math.cos(Math.PI * 5 / 6), radius * Math.sin(Math.PI * 5 / 6) );
				graphics.lineTo( radius * Math.cos(Math.PI * 7 / 6), radius * Math.sin(Math.PI * 7 / 6) );
				graphics.lineTo( 0, -radius);
			}
		}
		
		public override function highlightIt( color:uint ):void
		{
			var radius:Number = RADIUS * 0.9;
			graphics.moveTo(0, -radius);
			graphics.lineStyle(1, color, 1);
			graphics.beginFill(color, 0.15);
			graphics.lineTo( radius * Math.cos(-Math.PI / 6), radius * Math.sin(-Math.PI / 6) );
			graphics.lineTo( radius * Math.cos(Math.PI / 6), radius * Math.sin(Math.PI / 6) );
			graphics.lineTo( 0, radius);
			graphics.lineTo( radius * Math.cos(Math.PI * 5 / 6), radius * Math.sin(Math.PI * 5 / 6) );
			graphics.lineTo( radius * Math.cos(Math.PI * 7 / 6), radius * Math.sin(Math.PI * 7 / 6) );
			graphics.lineTo( 0, -radius);
			graphics.endFill();
		}
		
	}
}