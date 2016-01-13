package com.application.ocgsee.proxys
{
	import com.application.ocgsee.utils.localize;
	
	import mvclite.proxys.Proxy_Lite;
	
	public class ConfigProxy extends Proxy_Lite
	{
		public function ConfigProxy(data:Object=null)
		{
			super(data);
		}
		private var _config:XML;
		private function get config():XML{
			if(!_config){
				var assetsProxy:AssetsProxy=appFacade.retrieveProxy_Lite(AssetsProxy) as AssetsProxy;
				_config=assetsProxy.takeXML("Label_Config");
			}
			return _config;
		}
		public function getName(itemId:String,childId:String):String{
			var str:String= config.item.(@id==itemId).child.(@id==childId).@label;
			return localize(str);
		}
	}
}