package com.application.ocgsee.models
{
	import com.application.ocgsee.utils.CardSortUtils;

	public class CardsAnalysis
	{

		private var _list:Array;

		private var monsterList:Array;

		private var NAMList:Array;

		private var spellList:Array;

		private var trapList:Array;

		public function CardsAnalysis(list:Array)
		{
			_list=list;
			init();
		}
		
		private function init():void
		{
			monsterList=CardSortUtils.getMonsterList(_list);
			NAMList=CardSortUtils.getNAMList(_list);
			spellList=CardSortUtils.getSpellList(NAMList);
			trapList=CardSortUtils.getTrapList(NAMList);
		}
		private function getMonsterCount():int{
			return monsterList.length;
		}
		private function getSpellCount():int{
			return spellList.length;
		}
		private function getTrapCount():int{
			return trapList.length;
		}
		public function get text():String{
			return "搜索结果:"+_list.length+"  怪兽卡:"+getMonsterCount()+"  魔法卡:"+getSpellCount()+"  陷阱卡:"+getTrapCount();
		}
	}
}