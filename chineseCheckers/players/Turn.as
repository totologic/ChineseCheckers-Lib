package chineseCheckers.players
{
	public class Turn
	{
		
		private var _controlerCell:uint;
		private var _fromCellX:uint;
		private var _fromCellY:uint;
		private var _toCellX:uint;
		private var _toCellY:uint;
		
		public function Turn( controlerCell:uint
							, fromCellX:uint
							, fromCellY:uint
							, toCellX:uint
							, toCellY:uint )
		{
			_controlerCell = controlerCell;
			_fromCellX = fromCellX;
			_fromCellY = fromCellY;
			_toCellX = toCellX;
			_toCellY = toCellY;
		}
		
		public function get controlerCell():uint	{	return _controlerCell;	}
		public function get fromCellX():uint	{	return _fromCellX;	}
		public function get fromCellY():uint	{	return _fromCellY;	}
		public function get toCellX():uint	{	return _toCellX;	}
		public function get toCellY():uint	{	return _toCellY;	}

	}
}