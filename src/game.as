package {
	import chineseCheckers.StageInstance;
	import chineseCheckers.players.AbstractPlayer;
	import chineseCheckers.players.HumanPlayerMouse;
	import chineseCheckers.players.AIPlayerBestOpeningByDepthSearch;
	import chineseCheckers.players.AIPlayerMinMax;
	import chineseCheckers.display.AbstractDisplay;
	import chineseCheckers.display.Console;
	import chineseCheckers.display.SimpleDisplay;
	import chineseCheckers.games.DuoGame;
	import chineseCheckers.grid.Grid;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	[SWF(width="800", height="500")]
	public class game extends Sprite
	{
		private var grid:Grid;
		private var simpleDisplay:SimpleDisplay;
		private var player0:AbstractPlayer;
		private var player1:AbstractPlayer;
		private var display:AbstractDisplay;
		private var console:Console;
		private var theGame:DuoGame;
		
		
		public function game()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			StageInstance.STAGE = stage;
			
			// grids can be built using the editor
			//var configGrid:String = "10#11#3,4,5,6,4,5,6,2,3,4,5,6,7,2,3,4,6,7,8,1,2,3,6,7,8,2,3,4,6,7,8,2,3,4,5,6,7,4,5,6,3,4,5,6#1,1,1,1,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,5,5,5,5,5,5,6,6,6,6,6,6,7,7,7,7,7,7,8,8,8,9,9,9,9#4,4,4,4,4,4,4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,3,3,3,3,3,3";
			//var configGrid:String = "6#9#2,2,3,1,2,3,1,2,3,4,1,2,3,2,3,2#1,2,2,3,3,3,4,4,4,4,5,5,5,6,6,7#4,4,4,1,1,1,1,1,1,1,1,1,1,3,3,3";
			//var configGrid:String = "8#13#3,3,4,2,3,4,2,3,4,5,1,2,3,4,5,1,2,3,4,5,6,1,2,3,4,5,2,3,4,5,2,3,4,3,4,3#1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,6,6,6,6,6,6,7,7,7,7,7,8,8,8,8,9,9,9,10,10,11#4,4,4,1,4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,3,3,3";
			//var configGrid:String = "11#19#5,5,6,4,5,6,4,5,6,7,3,4,5,6,7,3,4,5,6,7,8,2,3,4,5,6,7,8,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8,9,2,3,4,5,6,7,8,9,2,3,4,5,6,7,8,3,4,5,6,7,8,3,4,5,6,7,4,5,6,7,4,5,6,5,6,5#1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,6,6,6,6,6,6,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,12,12,12,12,12,12,13,13,13,13,13,14,14,14,14,15,15,15,16,16,17#4,4,4,4,4,4,4,4,4,4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,3,3,3,3,3,3,3,3,3";
			//var configGrid:String = "14#25#6,6,7,5,6,7,5,6,7,8,4,5,6,7,8,4,5,6,7,8,9,3,4,5,6,7,8,9,3,4,5,6,7,8,9,10,2,3,4,5,6,7,8,9,10,2,3,4,5,6,7,8,9,10,11,1,2,3,4,5,6,7,8,9,10,11,1,2,3,4,5,6,7,8,9,10,11,12,1,2,3,4,5,6,7,8,9,10,11,2,3,4,5,6,7,8,9,10,11,2,3,4,5,6,7,8,9,10,3,4,5,6,7,8,9,10,3,4,5,6,7,8,9,4,5,6,7,8,9,4,5,6,7,8,5,6,7,8,5,6,7,6,7,6#1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,6,6,6,6,6,6,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,15,16,16,16,16,16,16,16,16,17,17,17,17,17,17,17,18,18,18,18,18,18,19,19,19,19,19,20,20,20,20,21,21,21,22,22,23#4,4,4,4,4,4,4,4,4,4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,3,3,3,3,3,3,3,3,3";
			var configGrid:String = "15#19#7,7,8,6,7,8,6,7,8,9,1,2,3,4,5,6,7,8,9,10,11,12,13,2,3,4,5,6,7,8,9,10,11,12,13,2,3,4,5,6,7,8,9,10,11,12,3,4,5,6,7,8,9,10,11,12,3,4,5,6,7,8,9,10,11,3,4,5,6,7,8,9,10,11,12,2,3,4,5,6,7,8,9,10,11,12,2,3,4,5,6,7,8,9,10,11,12,13,1,2,3,4,5,6,7,8,9,10,11,12,13,6,7,8,9,6,7,8,7,8,7#1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,15,15,15,16,16,17#4,4,4,4,4,4,4,4,4,4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,3,3,3,3,3,3,3,3,3";
			
			// choose the players types
			player0 = new HumanPlayerMouse();
			//player1 = new AIPlayerBestOpeningByDepthSearch();
			player1 = new AIPlayerMinMax();
			
			display = new SimpleDisplay();
			console = new Console( new MC_gameConsole() );
			theGame = new DuoGame();
			theGame.init( configGrid, display, player0, player1, console );
			
			addChild( display.content );
			addChild( console.content );
			
			console.content.height = stage.stageHeight;
			console.content.scaleX = console.content.scaleY;
			console.content.x = int(stage.stageWidth - console.content.width);
			
			var maxWidth:Number = stage.stageWidth - console.content.width;
			var maxHeight:Number = stage.stageHeight;
			display.content.width = maxWidth;
			display.content.scaleY = display.content.scaleX;
			if ( display.content.height > maxHeight )
			{
				display.content.height = maxHeight;
				display.content.scaleX = display.content.scaleY;
			}
			
			display.content.x = int((maxWidth - display.content.width) / 2);
			display.content.y = int((maxHeight - display.content.height) / 2);
			
			console.addMessage("Welcome !");
			console.addMessage("Computer plays with green pawns");
			console.addMessage("while you play with red pawns.");
			console.addMessage("");
			console.addMessage("");
			theGame.start();
		}
		
	}
}
