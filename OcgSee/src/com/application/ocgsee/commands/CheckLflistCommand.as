package com.application.ocgsee.commands
{
	import flash.filesystem.File;
	
	import mvclite.contorl.SimpleCommand_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import starling.utils.formatString;
	
	public class CheckLflistCommand extends SimpleCommand_Lite
	{
		public function CheckLflistCommand()
		{
			super();
		}
		public override function execute(notification:INotification):void{
			var appFile:File=File.applicationDirectory.resolvePath("assets/lflist");
			var fileList:Array=appFile.getDirectoryListing();
			for each(var file:File in fileList){
				var filePath:String=formatString("lflist/{0}",file.name);
				var storageFile:File=File.applicationStorageDirectory.resolvePath(filePath);
				if(!storageFile.exists){
					file.copyTo(storageFile);
				}
			}
		}
	}
}