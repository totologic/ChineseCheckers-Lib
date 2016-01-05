package chineseCheckers
{
	public class Colors
	{
		
		public static function GET_COLOR( cellType:uint ):uint
		{
			var color:uint;
			switch ( cellType )
			{
				case CellTypes.NONE :
					color = 0x333333;
				break;
				//
				case CellTypes.EMPTY :
					color = 0xFFFFFF;
				break;
				//
				case CellTypes.FULL :
					color = 0xCCCCCC;
				break;
				//
				case CellTypes.PLAYER0 :
					color = 0xFF0000;
				break;
				//
				case CellTypes.PLAYER1 :
					color = 0x00FF00;
				break;
				//
				case CellTypes.PLAYER2 :
					color = 0x0000FF;
				break;
				//
				case CellTypes.PLAYER3 :
					color = 0xFFFF00;
				break;
				//
				case CellTypes.PLAYER4 :
					color = 0xFF00FF;
				break;
				//
				case CellTypes.PLAYER5 :
					color = 0x00FFFF;
				break;
			}
			return color;
		}
		
		public static function GET_PLAYER_COLOR_NAME( color:uint ):String
		{
			var name:String;
			switch ( color )
			{
				case 0xFF0000 :
					name = "red";
					break;
				//
				case 0x00FF00 :
					name = "green";
					break;
				//
				case 0x0000FF :
					name = "blue";
					break;
				//
				case 0xFFFF00 :
					name = "yellow";
					break;
				//
				case 0xFF00FF :
					name = "pink";
					break;
				//
				case 0x00FFFF :
					name = "cyan";
					break;
			}
			return name;
		}
		
	}
}