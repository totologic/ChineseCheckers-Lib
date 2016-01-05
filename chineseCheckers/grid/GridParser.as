package chineseCheckers.grid
{
	public class GridParser
	{
		public static function parse(config:String):Grid
		{
			var grid:Grid;
			var aX:Array;
			var aY:Array;
			var aType:Array;
			var aXint:Array;
			var aYint:Array;
			var aTypeInt:Array;
		
			var splited:Array = config.split("#");
			grid = new Grid( int(splited[0]), int(splited[1]) );
			aX = String(splited[2]).split(",");
			aY = String(splited[3]).split(",");
			aType = String(splited[4]).split(",");
			
			aXint = new Array();
			aYint = new Array();
			aTypeInt = new Array();
			var i:int;
			for ( i=0 ; i<aX.length ; i++ )
			{
				aXint.push( int(aX[i]) );
			}
			for ( i=0 ; i<aY.length ; i++ )
			{
				aYint.push( int(aY[i]) );
			}
			for ( i=0 ; i<aType.length ; i++ )
			{
				aTypeInt.push( int(aType[i]) );
			}
			
			grid.init(aXint, aYint, aTypeInt);
			return grid;
		}

	}
}