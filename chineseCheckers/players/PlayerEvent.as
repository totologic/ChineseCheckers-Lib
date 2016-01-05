package chineseCheckers.players
{
	import flash.events.Event;
	
	public class PlayerEvent extends Event
	{
		
		public static const TURN_PLAYED:String = "turnPlayed";
		
		private var _turn:Turn;
		
		public function PlayerEvent( type:String, turn:Turn )
		{
			super( type );
			_turn = turn;
		}
		
		public function get turn():Turn		{	return _turn;	}
		
		public override function clone():Event
		{
			return new PlayerEvent( this.type, this._turn );
		}
		
	}
}