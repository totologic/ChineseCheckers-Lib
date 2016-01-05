package chineseCheckers.display
{
	import flash.display.Sprite;
	import flash.text.TextField;

	public class Console
	{
		
		private var _content:Sprite;
		private var _tf:TextField;
		
		public function Console( content:Sprite )
		{
			_content = content;
			_tf = _content["tf"];
			_tf.text = "";
		}

		public function get content():Sprite
		{
			return _content;
		}
		
		public function addMessage( message:String ):void
		{
			_tf.appendText( message + "\n" );
			_tf.scrollV = _tf.maxScrollV;
		}

	}
}