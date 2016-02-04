package com.application.ocgsee.proxys
{
	import com.application.ocgsee.models.GlobalModel;
	
	import flash.filesystem.File;
	
	import mvclite.proxys.Proxy_Lite;
	
	import starling.utils.formatString;
	
	public class GlobalProxy extends Proxy_Lite
	{
		public var model:GlobalModel;
		
		public const KEY_CURRENT_DB:String="current_DB";
		public const KEY_LAST_DB:String="last_DB";
		
		public const DB_DIR:String="db/";
		
		public var lastIDList:Array=[];
		
		public function isNewCard(id:int):Boolean{
			var re:Boolean=false;
			if(lastIDList.length){
				re=lastIDList.indexOf(id)==-1
			}
			return re;
		}
		public function get SERVER_HEAD():String{
			return model.SERVER_HEAD
		}
		
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
		
		public function getRemoteUri(id:int):String{
			return formatString(model.PICS_API,id);
		}
		public function isRemoteUri(uri:String):Boolean{
			return uri.indexOf(model.SERVER_HEAD)!=-1
		}
		/**
		 * 从Remote uri里获取到xxx.jpg
		 * @param remoteUri
		 * @return 
		 * 
		 */		
		public function getCardJPG(remoteUri:String):String{
			remoteUri=remoteUri.split("\\").join("/");
			var temp:Array=remoteUri.split("/");
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
			var saveFile:File=File.applicationStorageDirectory.resolvePath(formatString("image/{0}",cardJPG));
			return saveFile;
		}
	}
}