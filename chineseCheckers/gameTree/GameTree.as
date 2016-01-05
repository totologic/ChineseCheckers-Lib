package chineseCheckers.gameTree
{
	public final class GameTree
	{
		
		private var _root:GameNode;
		
		public function GameTree()
		{
			_root = new GameNode(null);
		}
		
		public function get root():GameNode
		{
			return _root;
		}
		
		public function empty():void
		{
			_root.destroyRecursively();
			_root = new GameNode(null);
		}
		
		
		// BROWSING //
		
		private var _depthBrowsing:int;
		private var _indexBrowsingArray:Vector.<int> = new Vector.<int>;
		public function beginNodeBrowsing( atDepth:int ):void
		{
			_depthBrowsing = atDepth;
			_indexBrowsingArray.splice(0, _indexBrowsingArray.length);
			for ( var i:int=0 ; i<_depthBrowsing + 1 ; i++ )
			{
				_indexBrowsingArray.push(0);
			}
			_jumpingNode = _root;
		}
		
		private var _jumpingNode:GameNode;
		public function nextNode():GameNode
		{
			if ( _depthBrowsing == 0 )
			{
				if ( _jumpingNode )
				{
					_jumpingNode = null;
					return _root;
				}
				return null;
			}
			
			if ( _jumpingNode && _jumpingNode != _root )
				_jumpingNode = _jumpingNode.parent;
			
			while ( _jumpingNode && (_jumpingNode.depth < _depthBrowsing) )
			{
				if ( _indexBrowsingArray[_jumpingNode.depth+1] < _jumpingNode.children.length )
				{
					_jumpingNode = _jumpingNode.children[_indexBrowsingArray[_jumpingNode.depth+1]];
				}
				else
				{
					if ( _jumpingNode != _root )
					{
						_indexBrowsingArray[_jumpingNode.depth] += 1;
						_indexBrowsingArray[_jumpingNode.depth+1] = 0;
						_jumpingNode = _jumpingNode.parent;
					}
					else
					{
						_jumpingNode = null;
					}
				}
			}
			_indexBrowsingArray[_depthBrowsing] += 1;
			return _jumpingNode;
		}

	}
}