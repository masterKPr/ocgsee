package com.application.ocgsee.commands
{
	import com.application.ocgsee.proxys.CardsSearchProxy;
	
	import mvclite.contorl.SimpleCommand_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class SearchCommand extends SimpleCommand_Lite
	{
		public function SearchCommand()
		{
			super();
		}
		public override function execute(notification:INotification):void{
			var text:String=String(notification.getBody());
			var proxy:CardsSearchProxy=appFacade.retrieveProxy_Lite(CardsSearchProxy) as CardsSearchProxy;
			proxy.text=text;
			proxy.excecute(notification.getType());
		}
	}
}