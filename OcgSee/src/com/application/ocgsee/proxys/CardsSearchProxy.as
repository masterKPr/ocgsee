package com.application.ocgsee.proxys
{
	import com.application.engine.search.SearchEngine;
	
	import flash.utils.ByteArray;
	
	import framework.log.LogUtils;
	
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
		public function excecute(text:String,resultHandler:Function):void{
			model.text=text;
			model.execute();
			var result:Array=model.getResult().data;
			if(!result)result=[];
			LogUtils.log("查询结果-->数目:"+result.length);
			resultHandler(result);
		}
		
		
	}
}