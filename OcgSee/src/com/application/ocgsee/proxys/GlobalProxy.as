package com.application.ocgsee.proxys
{
	import flash.filesystem.File;
	
	import mvclite.proxys.Proxy_Lite;
	
	import starling.utils.formatString;
	
	public class GlobalProxy extends Proxy_Lite
	{
		
		public const SERVER_HEAD:String="http://ocgsee.applinzi.com/";
		public const PICS_API:String=SERVER_HEAD+"pics/{0}.jpg";
		public const SERVER_UPDATE:String=SERVER_HEAD+"dbVersion.xml";
		
		public var showCard:Boolean;
		
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
		
		public function GlobalProxy(data:Object=null)
		{
			super(data);
		}
		private var _isDrawOpen:Boolean;
		public function get isDrawOpen():Boolean
		{
			return _isDrawOpen;
		}
		
		public function set isDrawOpen(value:Boolean):void
		{
			_isDrawOpen = value;
		}
		
		public function getRemoteUri(id:int):String{
			return formatString(PICS_API,id);
		}
		public function isRemoteUri(uri:String):Boolean{
			return uri.indexOf(SERVER_HEAD)!=-1;
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
			return formatString("{0}.jpg",id);
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