package com.application.ocgsee.proxys
{
	import com.application.engine.search.SearchEngine;
	import com.application.ocgsee.consts.GlobalEvents;
	
	import flash.utils.ByteArray;
	
	import mvclite.notification.LogEvents;
	import mvclite.proxys.Proxy_Lite;
	
	public class CardsSearchProxy extends Proxy_Lite
	{
		public var model:SearchEngine;
		public function CardsSearchProxy(data:Object=null)
		{
			super(data);
		}

		public  function open(reference:Object=null, openMode:String="create", autoCompact:Boolean=false, pageSize:int=1024, encryptionKey:ByteArray=null):void{
			if(model.connection.connected){
				model.connection.close();
			}
			model.connection.open(reference,openMode,autoCompact,pageSize,encryptionKey);
		}
		private var _text:String;
		
		public function get text():String
		{
			return _text;
		}
		
		public function set text(value:String):void
		{
			_text = value;
		}
		public function excecute(type:String):void{
			model.text=_text;
			model.execute();
			
			var result:Array=model.getResult().data;
			if(!result)result=[];
			sendNotification(LogEvents.LOG,"数目:"+result.length,"查询结果")
			sendNotification(GlobalEvents.SEARCH_COMPLETE,result,type);
		}
		
		
	}
}