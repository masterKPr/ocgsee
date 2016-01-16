package com.application.ocgsee.proxys
{
	import com.application.engine.search.SearchEngine;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import framework.log.LogUtils;
	
	import mvclite.proxys.Proxy_Lite;
	
	public class CardsSearchProxy extends Proxy_Lite
	{
		public var model:SearchEngine;

		public var fileName:String;
		public function CardsSearchProxy(data:Object=null)
		{
			super(data);
		}

		public  function open(reference:Object=null, openMode:String="create", autoCompact:Boolean=false, pageSize:int=1024, encryptionKey:ByteArray=null):void{
			if(model.connection.connected){
				model.connection.close();
			}
			var file:File=reference as File;
			var temp:Array=file.url.split("/");
			fileName=temp[temp.length-1];
			model.connection.open(reference,openMode,autoCompact,pageSize,encryptionKey);
		}
		public function excecute(text:String,resultHandler:Function=null):Array{
			model.text=text;
			model.execute();
			var result:Array=model.getResult().data;
			if(!result)result=[];
			LogUtils.log("查询结果-->数目:"+result.length);
			resultHandler&&resultHandler(result);
			return result
		}
		
		
	}
}