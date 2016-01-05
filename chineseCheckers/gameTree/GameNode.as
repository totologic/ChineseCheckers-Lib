package chineseCheckers.gameTree
{
	public final class GameNode
	{
		private var _parent:GameNode;
		private var _depth:int;
		private var _value:Object;
		private var _children:Vector.<GameNode>;
		
		public function GameNode( parent:GameNode )
		{
			_parent = parent;
			if ( _parent )
				_depth = _parent.depth + 1;
			else
				_depth = 0;
			_value = new Object();
			_children = new Vector.<GameNode>();
		}
		
		public function get parent():GameNode	{	return _parent;		}
		public function get depth():int			{	return _depth;		}
		public function get value():Object		{	return _value;		}
		public function get children():Vector.<GameNode>	{	return _children;	}
		
		public function addChild():GameNode
		{
			var gameNode:GameNode;
			gameNode = new GameNode( this );
			_children.push( gameNode );
			return gameNode;
		}
		
		public function removeChild( child:GameNode, destroyItRecursively:Boolean=false ):void
		{
			var index:int;
			if ( (index = _children.indexOf(child)) != -1 )
			{
				_children.splice(index, 1);
				if ( destroyItRecursively )
					child.destroyRecursively();
			}
		}
		
		private var __nodeIndex:int;
		public function browseChildren():void
		{
			__nodeIndex = 0;
		}
		
		public function next():GameNode
		{
			if ( __nodeIndex < _children.length )
				return _children[__nodeIndex];
			else
				return null;
		}
		
		public function destroy():void
		{
			_parent = null;
			_value = null;
			_children.splice(0, _children.length);
			_children = null;
		}
		
		public function destroyRecursively():void
		{
			while ( _children.length )
			{
				GameNode(_children.pop()).destroyRecursively();
			}
			this.destroy();
		}

	}
}