package com.application.ocgsee.proxys
{
	import com.application.ocgsee.models.SQLText;
	
	import mvclite.notification.LogEvents;
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
			sendNotification(LogEvents.LOG,re,"查询语句");
			return re;
		}
		public function singleCardSQL(id:int):String{
			var re:String=model.SEARCH_SINGLE_HEAD+id;
			sendNotification(LogEvents.LOG,re,"查询单卡");
			return re;
		}
		
	}
}