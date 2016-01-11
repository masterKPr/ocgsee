package com.application.ocgsee.utils
{
	import com.application.ocgsee.consts.CardConst;

	public class CardSortUtils
	{
		public function CardSortUtils()
		{
		}
		public static function getMonsterList(list:Array):Array{
			return list.filter(isMonster);
		}
		/**
		 * 获取一个Not a Monster数组
		 * @return 
		 * 
		 */		
		public static function getNAMList(list:Array):Array{
			return list.filter(isNoMonster);
		}
		
		public static function getSpellList(list:Array):Array{
			return list.filter(isSpell);
		}
		public static function getTrapList(list:Array):Array{
			return list.filter(isTrap);
		}
		
		public static function sortCardList(list:Array,fields:Array,options:Array):Array{
			var re:Array;
			var monsterList:Array=getMonsterList(list);
			monsterList.sortOn(fields,options);
			var noMonsterList:Array=getNAMList(list);
			noMonsterList=defaultSortNAM(noMonsterList);
			re=monsterList.concat(noMonsterList);
			return re;
		}

		private static function defaultSortNAM(list:Array):Array{
			var re:Array;
			var spellList:Array=list.filter(isSpell);
			var trapList:Array=list.filter(isTrap);
			spellList.sortOn([CardConst.TYPE,CardConst.ID],Array.NUMERIC);
			trapList.sortOn([CardConst.TYPE,CardConst.ID],Array.NUMERIC);
			re=spellList.concat(trapList)
			return re;
		}
		private static function isSpell(item:*, index:int, array:Array):Boolean{
			return Boolean((item.type>>1)&0x1)
		}
		private static function isTrap(item:*, index:int, array:Array):Boolean{
			return Boolean((item.type>>2)&0x1)
		}
		private static function isMonster(item:*, index:int, array:Array):Boolean{
			return ((item.type%2)==1);
		}
		private static function isNoMonster(item:*, index:int, array:Array):Boolean{
			return ((item.type%2)==0);
		}
	}
}