package com.application.ocgsee.proxys
{
	import com.application.ocgsee.models.GlobalModel;
	
	import flash.filesystem.File;
	
	import mvclite.proxys.Proxy_Lite;
	
	import starling.utils.formatString;
	
	public class GlobalProxy extends Proxy_Lite
	{
		public var model:GlobalModel;
		public function GlobalProxy(data:Object=null)
		{
			super(data);
		}

		public function get isDrawOpen():Boolean
		{
			return model.drawOpen
		}

		public function set isDrawOpen(value:Boolean):void
		{
			model.drawOpen = value;
		}

		public function getMyCardUri(id:int):String{
			return formatString(model.MC_API,id);
		}
		public function isMCCardUri(uri:String):Boolean{
			return uri.indexOf(model.MC_HEAD)!=-1
		}
		/**
		 * 从MC uri里获取到xxx.jpg
		 * @param mcUrl
		 * @return 
		 * 
		 */		
		public function getCardJPG(mcUrl:String):String{
			mcUrl=mcUrl.split("\\").join("/");
			var temp:Array=mcUrl.split("/");
			var id:String=temp[temp.length-1];
			return id;
		}
		/**
		 *通过ID获取CardJPG字符串 
		 * @param id
		 * @return 
		 * 
		 */		
		public function get_CardJPG_ID(id:int):String{
			return id+".jpg"
		}
		/**
		 *根据 CardJPG获取id
		 * @param cardJPG
		 * @return 
		 * 
		 */		
		public function get_ID_CardJPG(cardJPG:String):int{
			return int(cardJPG.split(".")[0])
		}
		
		public function get_File_CardJPG(cardJPG:String):File{
			var saveFile:File=File.applicationStorageDirectory.resolvePath("image/"+cardJPG);
			return saveFile;
		}
	}
}