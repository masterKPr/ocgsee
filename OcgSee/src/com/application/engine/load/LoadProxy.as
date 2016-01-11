package com.application.engine.load
{
	
	
	import mvclite.proxys.Proxy_Lite;
	
	public class LoadProxy extends Proxy_Lite
	{
		public var model:LoadModel;
		public function LoadProxy(data:Object=null)
		{
			super(data);
		}
		public function registLoader(url:String,mediatorClass:Class,viewClass:Class):void{
			var loadingData:LoadData=new LoadData();
			loadingData.url=url;
			loadingData.mediator=mediatorClass;
			loadingData.view=viewClass;
			model.dict[url]=loadingData;
		}
		public function getLoader(url:String):LoadData{
			return model.dict[url];
		}
		
	}
}