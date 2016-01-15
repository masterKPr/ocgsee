package com.application.ocgsee.commands
{
	import com.application.ApplicationFacade;
	import com.application.engine.utils.FileUtils;
	import com.application.ocgsee.consts.GlobalEvents;
	import com.application.ocgsee.proxys.CardsSearchProxy;
	import com.application.ocgsee.proxys.GlobalProxy;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import mvclite.contorl.SimpleCommand_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class CheckDBCommand extends SimpleCommand_Lite
	{

		private var urlLoader:URLLoader;

		private var fileName:String;

		private var DBPath:String;
		public function CheckDBCommand()
		{
			super();
		}
		public override function execute(notification:INotification):void{
			urlLoader=new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE,onComplete);
			
			urlLoader.load(new URLRequest(globalProxy.SERVER_HEAD+"dbVersion.xml"));
		}
		
		protected function onComplete(event:Event):void
		{
			var str:String=urlLoader.data;
			var xml:XML=XML(str);
			var xmlDBPath:String=xml.db;
			var temp:Array=xmlDBPath.split("/");
			fileName=temp[temp.length-1];
			DBPath=globalProxy.DB_DIR+fileName;
			var localFile:File=File.applicationStorageDirectory.resolvePath(DBPath);
			if(!localFile.exists){
				var dbLoader:URLLoader=new URLLoader();
				dbLoader.dataFormat=URLLoaderDataFormat.BINARY;
				dbLoader.load(new URLRequest(xmlDBPath));
				dbLoader.addEventListener(Event.COMPLETE,onDBComplete);
			}
		}
		private function get globalProxy():GlobalProxy{
			return ApplicationFacade._.globalProxy;
		}
		protected function onDBComplete(e:Event):void
		{
			var bytes:ByteArray=e.target.data;
			
			bytes.position=0;
			bytes.uncompress();
			bytes.position=0;
			
			
			var localFile:File=File.applicationStorageDirectory.resolvePath(DBPath);
			var fileStream:FileStream=new FileStream();
			fileStream.open(localFile,FileMode.WRITE);
			fileStream.writeBytes(bytes);
			fileStream.close();
			
			var configFile:File=File.applicationStorageDirectory.resolvePath(globalProxy.DB_CONFIG);
			FileUtils.writeString(configFile,fileName);
			
			sendNotification(GlobalEvents.INIT_DB);
		}
	}
}