package com.application.engine.local
{
	
	import framework.log.LogUtils;
	
	import mvclite.proxys.Proxy_Lite;
	
	import starling.utils.AssetManager;
	import starling.utils.formatString;
	
	public class LocaleProxy extends Proxy_Lite
	{
		public var model:AssetManager;
		public function LocaleProxy(data:Object=null)
		{
			super(data);
		}
		public function localize(key:String, ...args):String
		{
			var re:String;
			var dict:Object=model.getObject("language");
			if(dict.hasOwnProperty(key))
			{
				re= dict[key];
				if (args.length > 0)
				{
					args.unshift(re);
					re=formatString.apply(null,args);
				}
			}
			else
			{
				re= key;
				LogUtils.error("locale key null:"+key);
			}
			re="."+re
			return re;
		}
	}
}