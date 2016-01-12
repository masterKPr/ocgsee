package com.application.ocgsee.proxys
{
	import com.application.engine.utils.FileUtils;
	import com.application.ocgsee.consts.GlobalEvents;
	
	import flash.filesystem.File;
	
	import mvclite.proxys.Proxy_Lite;
	
	import starling.utils.AssetManager;
	
	public class LoaderProxy extends Proxy_Lite
	{
		public var model:AssetManager;
		public function LoaderProxy(data:Object=null)
		{
			super(data);
		}
		public function begin():void{
			config("system/loadConfig.xml");
		}
		public function config(uri:String):void{
			var file:File=File.applicationDirectory.resolvePath(uri)
			var str:String=FileUtils.readFile(file);
			var xml:XML=new XML(str);
			var xls:XMLList=xml.item;
			for each(var item:XML in xls){
				var url:String=item.@url;
				model.enqueue(url);
			}
			model.loadQueue(packageComplete);
		}
		private function packageComplete(ratio:Number):void{
			if(ratio==1.0){
				sendNotification(GlobalEvents.RES_COMPLETE);
			}else{
				sendNotification(GlobalEvents.LOADING_PROGRESS,ratio);
			}
		}

		
	}
}