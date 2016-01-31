package com.application.ocgsee.commands
{
	import com.application.ocgsee.consts.GlobalNotifications;
	import com.application.ocgsee.proxys.CardsSearchProxy;
	
	import mvclite.contorl.SimpleCommand_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class SearchCommand extends SimpleCommand_Lite
	{
		public function SearchCommand()
		{
			super();
		}
		private function callBack(commandName:String):Function{
			return function(result:Object):void{
				sendNotification(commandName,result);
			}
		}
		public override function execute(notification:INotification):void{
			var text:String=String(notification.getBody());
			var proxy:CardsSearchProxy=appFacade.retrieveProxy_Lite(CardsSearchProxy) as CardsSearchProxy;
			
			var commandName:String;
			if(notification.getName()==GlobalNotifications.SEARCH_MULIT)
			{
				commandName=GlobalNotifications.SEARCH_MULIT_COMPLETE;
			}else{
				commandName=GlobalNotifications.SEARCH_SINGLE_COMPLETE;
			}
			proxy.excecute(text,callBack(commandName));
		}
	}
}