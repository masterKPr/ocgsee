package com.application.ocgsee.commands
{
	import com.application.engine.utils.FileUtils;
	import com.application.ocgsee.consts.GlobalEvents;
	import com.application.ocgsee.proxys.CardsSearchProxy;
	
	import flash.filesystem.File;
	
	import mvclite.contorl.SimpleCommand_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import starling.utils.formatString;
	
	public class StatisticsDBCommand extends SimpleCommand_Lite
	{
		/**
		 *统计DB卡数的 
		 * 
		 */		
		public function StatisticsDBCommand()
		{
			super();
		}
		private function mapID(item:*, index:int, array:Array):int{
			return item["id"];
		}
		public override function execute(notification:INotification):void{
			
			var proxy:CardsSearchProxy=appFacade.retrieveProxy_Lite(CardsSearchProxy) as CardsSearchProxy;
			var dataName:String=formatString("data/{0}.json",proxy.fileName.split(".")[0]);
			var dataFile:File=File.applicationStorageDirectory.resolvePath(dataName);
			if(!dataFile.exists){
				var text:String="select id from datas";
				var result:Array=proxy.excecute(text);
				var idList:Array=result.map(mapID)
				var jsonStr:String=JSON.stringify(idList);
				FileUtils.writeString(dataFile,jsonStr);
			}
			sendNotification(GlobalEvents.LOAD_STATISTICS);

		}
	}
}