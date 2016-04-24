package com.application.ocgsee.proxys
{
	import framework.log.LogUtils;
	
	import mvclite.proxys.Proxy_Lite;
	
	import starling.utils.formatString;
	
	public class SQLProxy extends Proxy_Lite
	{
		public const SEARCH_RESULT_HEAD:String="select datas.id,datas.type,datas.atk,datas.def,datas.level,datas.attribute,datas.ot,datas.race from datas,texts where datas.id=texts.id";
		public const SEARCH_SINGLE_ID:String="select datas.id,datas.type,datas.atk,datas.def,datas.level,datas.attribute,datas.ot,datas.race,texts.name,texts.desc from datas,texts where datas.id=texts.id and datas.id={0}";
		public function SQLProxy(data:Object=null)
		{
			super(data);
		}
		public function searchMultiSQL(terms:String):String{
			var re:String=SEARCH_RESULT_HEAD+terms;
			var template:String="查询多卡语句-->{0}";
			LogUtils.log(formatString(template,re));
			return re;
		}
		public function singleCardSQL(id:int):String{
			var re:String=formatString(SEARCH_SINGLE_ID,id);
			var template:String="查询单卡语句-->{0}";
			LogUtils.log(formatString(template,re));
			return re;
		}
		
	}
}