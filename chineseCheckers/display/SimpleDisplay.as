package chineseCheckers.display
{
	import chineseCheckers.Colors;
	import chineseCheckers.grid.Grid;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	
	public class SimpleDisplay extends AbstractDisplay
	{
		
		private var _array:Array;
		
		public function SimpleDisplay()
		{
			_content = new Sprite();
		}
		
		public override function init(width:uint, height:uint):void
		{
			super.init(width, height);
			
			_array = new Array();
			var simpleCell:SimpleCell;
			for ( var y:int=0 ; y<_height ; y++  )
			{
				_array[y] = new Array();
				for ( var x:int=0 ; x<_width ; x++ )
				{
					simpleCell = new SimpleCell(x, y);
					simpleCell.x = ((1 + (y % 2))/ 2 + x) * (SimpleCell.WIDTH);
					simpleCell.y = SimpleCell.HEIGHT / 2 + y * 0.5 * (SimpleCell.LENGTH_EDGE + SimpleCell.HEIGHT);
					_content.addChild( simpleCell );
					_array[y][x] = simpleCell;
				}
			}
			_content.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public override function updateGrid(grid:Grid):void
		{
			for ( var y:int=0 ; y<_height ; y++  )
			{
				for ( var x:int=0 ; x<_width ; x++ )
				{
					SimpleCell(_array[y][x]).color = Colors.GET_COLOR(grid.getCell(x, y));
				}
			}
		}
		
		public override function setSelected(x:int, y:int, value:Boolean):void
		{
			SimpleCell(_array[y][x]).selectIt( value );
		}
		
		public override function highlight(aX:Array, aY:Array, cell:uint):void
		{
			for ( var i:int=0 ; i<aX.length ; i++ )
			{
				SimpleCell(_array[aY[i]][aX[i]]).highlightIt( Colors.GET_COLOR(cell) );
			}
		}
		
		//
		
		private function onClick(e:MouseEvent):void
		{
			dispatchEvent( new CellInteractionEvent(CellInteractionEvent.CELL_CLICK
													, SimpleCell(e.target).cellDataX
													, SimpleCell(e.target).cellDataY ) );
		}

	}
}