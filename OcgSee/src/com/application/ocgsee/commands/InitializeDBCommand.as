package com.application.ocgsee.commands
{
	import com.application.ApplicationFacade;
	import com.application.ocgsee.consts.GlobalNotifications;
	import com.application.ocgsee.proxys.CardsSearchProxy;
	import com.application.ocgsee.proxys.GlobalProxy;
	import com.application.ocgsee.proxys.KVDBProxy;
	
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
		private function get kvdb():KVDBProxy{
			return ApplicationFacade._.kvdb;
		}
		public override function execute(notification:INotification):void{
			var dbName:String;
			var configDB:String=kvdb.take(globalProxy.KEY_CURRENT_DB);
			if(configDB){
				dbName=configDB;
			}else{
				dbName=defaultDB;
				kvdb.save(globalProxy.KEY_CURRENT_DB,dbName);
			}
			
			var SQLFile:File;

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
			sendNotification(GlobalNotifications.STATISTICS_DB);
		}
	}
}