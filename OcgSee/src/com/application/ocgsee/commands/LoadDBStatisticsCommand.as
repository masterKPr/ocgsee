package com.application.ocgsee.commands
{
	import com.application.ApplicationFacade;
	import com.application.engine.utils.FileUtils;
	import com.application.ocgsee.proxys.GlobalProxy;
	import com.application.ocgsee.proxys.KVDBProxy;
	
	import flash.filesystem.File;
	
	import mvclite.contorl.SimpleCommand_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import starling.utils.formatString;
	
	public class LoadDBStatisticsCommand extends SimpleCommand_Lite
	{
		public function LoadDBStatisticsCommand()
		{
			super();
		}
		private function get globalProxy():GlobalProxy{
			return ApplicationFacade._.globalProxy;
		}
		private function get kvdb():KVDBProxy{
			return ApplicationFacade._.kvdb;
		}
		public override function execute(notification:INotification):void{
			
			var lastDBName:String=kvdb.take(globalProxy.KEY_LAST_DB);
			if(lastDBName){
				var dataName:String=formatString("data/{0}.json",lastDBName.split(".")[0]);
				var dataFile:File=File.applicationStorageDirectory.resolvePath(dataName);
				if(dataFile.exists){
					var str:String=FileUtils.readFile(dataFile);
					var result:Array=JSON.parse(str) as Array;
					globalProxy.lastIDList=result;
				}
			}
		}
	}
}