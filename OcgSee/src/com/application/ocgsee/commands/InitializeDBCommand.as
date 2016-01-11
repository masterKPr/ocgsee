package com.application.ocgsee.commands
{
	import com.application.ocgsee.proxys.CardsSearchProxy;
	
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
		public override function execute(notification:INotification):void{
			var SQLFile:File=File.applicationStorageDirectory.resolvePath("cards.cdb");
			if(!SQLFile.exists){
				var compressFile:File=File.applicationDirectory.resolvePath("compress.db")
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