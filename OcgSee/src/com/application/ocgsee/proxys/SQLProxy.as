package com.application.ocgsee.proxys
{
	import com.application.ocgsee.models.SQLText;
	
	import framework.log.LogUtils;
	
	import mvclite.proxys.Proxy_Lite;
	
	
	public class SQLProxy extends Proxy_Lite
	{
		public var model:SQLText;
		public function SQLProxy(data:Object=null)
		{
			super(data);
		}
		public function createTermsSQL(terms:String):String{
			var re:String=model.SEARCH_RESULT_HEAD+terms;
			LogUtils.log("查询语句-->"+re);
			return re;
		}
		public function singleCardSQL(id:int):String{
			var re:String=model.SEARCH_SINGLE_HEAD+id;
			LogUtils.log("查询单卡-->"+re);
			return re;
		}
		
	}
}