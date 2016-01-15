package com.application.ocgsee.commands
{
	import com.application.ApplicationFacade;
	import com.application.engine.utils.FileUtils;
	import com.application.ocgsee.proxys.CardsSearchProxy;
	import com.application.ocgsee.proxys.GlobalProxy;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mvclite.contorl.SimpleCommand_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class InitializeDBCommand extends SimpleCommand_Lite
	{
		public function InitializeDBCommand()
		{
			super();
		}
		private const defaultDB:String="cards.cdb";
		private function get globalProxy():GlobalProxy{
			return ApplicationFacade._.globalProxy;
		}
		private function createDefaultConfig():void{
			var file:File=File.applicationStorageDirectory.resolvePath(globalProxy.DB_CONFIG)
			var stream:FileStream=new FileStream();
			stream.open(file,FileMode.WRITE);
			stream.writeUTFBytes(defaultDB);
			stream.close();
		}
		public override function execute(notification:INotification):void{
			var configFile:File=File.applicationStorageDirectory.resolvePath(globalProxy.DB_CONFIG);
			var SQLFile:File;
			var dbName:String;
			if(!configFile.exists){
				createDefaultConfig();
				dbName=defaultDB;
			}else{
				dbName=FileUtils.readFile(configFile);
			}
			
			var DBPath:String=globalProxy.DB_DIR+dbName;
			SQLFile=File.applicationStorageDirectory.resolvePath(DBPath);
			
			if(!SQLFile.exists){
				var compressFile:File=File.applicationDirectory.resolvePath(defaultDB)
				var compressStream:FileStream=new FileStream();
				compressStream.open(compressFile,FileMode.READ);
				var bytes:ByteArray=new ByteArray();
				compressStream.readBytes(bytes);
				compressStream.close();
				bytes.position=0;
				bytes.uncompress();
				bytes.position=0;
				var stream:FileStream=new FileStream();
				stream.open(SQLFile,FileMode.WRITE);
				stream.writeBytes(bytes);
				stream.close();
			}
			
			var proxy:CardsSearchProxy=appFacade.retrieveProxy_Lite(CardsSearchProxy) as CardsSearchProxy;
			proxy.open(SQLFile);
		}
	}
}