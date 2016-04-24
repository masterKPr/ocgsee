package com.application.engine.local
{
	
	import com.application.ApplicationFacade;
	
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
				var template:String="locale key null:{0}";
				LogUtils.error(formatString(template,key));
			}
			
			return re;
		}
	}
}