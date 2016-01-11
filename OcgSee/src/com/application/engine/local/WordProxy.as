package com.application.engine.local
{
	import mvclite.proxys.Proxy_Lite;
	
	public class WordProxy extends Proxy_Lite
	{
		public var model:WordModel;
		public function WordProxy(data:Object=null)
		{
			super(data);
		}
		private static const HEAD:String="text://";
		public function trans(key:String):String{
			if(key.indexOf(HEAD)!=-1){
				var pureKey:String=key.split(HEAD).join("");
				return model.dict[pureKey];
			}else{
				return key;
			}
		}
		public function save(key:String,value:String):void{
			model[key]=value;
		}
	}
}