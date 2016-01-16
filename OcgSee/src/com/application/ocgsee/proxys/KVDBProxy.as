package com.application.ocgsee.proxys
{
	import com.application.engine.utils.FileUtils;
	
	import flash.filesystem.File;
	
	import mvclite.proxys.Proxy_Lite;
	
	public class KVDBProxy extends Proxy_Lite
	{
		public var dict:Object;
		public function KVDBProxy(data:Object=null)
		{
			super(data);
			init();
		}
		private const FILE:File=File.applicationStorageDirectory.resolvePath("kvdb.json")
		private function init():void
		{
			if(!FILE.exists){
				dict={};
				flush();
			}else{
				load();
			}
		}
		
		public function save(key:String,value:String):void{
			dict[key]=value;
			flush();
		}
		private function flush():void{
			var str:String=JSON.stringify(dict);
			FileUtils.writeString(FILE,str);
		}
		private function load():void{
			var str:String=FileUtils.readFile(FILE);
			dict=JSON.parse(str);
		}
		public function del(key:String):void{
			delete dict[key];
			flush();
		}
		public function take(key:String):String{
			return dict[key];
		}
	}
}