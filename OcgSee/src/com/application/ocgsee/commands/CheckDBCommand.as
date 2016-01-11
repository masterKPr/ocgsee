package com.application.ocgsee.commands
{
	import com.application.ocgsee.proxys.CardsSearchProxy;
	
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
		public function CheckDBCommand()
		{
			super();
		}
		public override function execute(notification:INotification):void{
			return 
			urlLoader=new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE,onComplete);
			urlLoader.load(new URLRequest("http://riaocg.sinaapp.com/dbVersion.xml"));
		}
		
		protected function onComplete(event:Event):void
		{
			var str:String=urlLoader.data;
			var xml:XML=XML(str);
			var dbPath:String=xml.db;
			var temp:Array=dbPath.split("/");
			fileName=temp[temp.length-1];
			var localFile:File=File.applicationStorageDirectory.resolvePath("db/"+fileName);
			if(!localFile.exists){
				var dbLoader:URLLoader=new URLLoader();
				dbLoader.dataFormat=URLLoaderDataFormat.BINARY;
				dbLoader.load(new URLRequest(dbPath));
				dbLoader.addEventListener(Event.COMPLETE,onDBComplete);
			}else{
				var proxy:CardsSearchProxy=appFacade.retrieveProxy_Lite(CardsSearchProxy) as CardsSearchProxy;
				proxy.open(localFile);
			}
		}
		
		protected function onDBComplete(e:Event):void
		{
			var byte:ByteArray=e.target.data;
			var localFile:File=File.applicationStorageDirectory.resolvePath("db/"+fileName);
			var fileStream:FileStream=new FileStream();
			fileStream.open(localFile,FileMode.WRITE);
			fileStream.writeBytes(byte);
			setTimeout(fileStream.close,1);
			var f:Function=function():void{
				var proxy:CardsSearchProxy=appFacade.retrieveProxy_Lite(CardsSearchProxy) as CardsSearchProxy;
				proxy.open(localFile);
			}
			setTimeout(f,2);
		}
	}
}