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
		public function get labelConfig():XML{
			var assetsProxy:AssetsProxy=appFacade.retrieveProxy_Lite(AssetsProxy) as AssetsProxy;
			return assetsProxy.takeXML("Label_Config");
		}
		
		public function get sqlConfig():XML{
			var assetsProxy:AssetsProxy=appFacade.retrieveProxy_Lite(AssetsProxy) as AssetsProxy;
			return assetsProxy.takeXML("SQL_Config");
		}
		
		public function getName(itemId:String,childId:String):String{
			var str:String= labelConfig.item.(@id==itemId).child.(@id==childId).@label;
			return localize(str);
		}
	}
}