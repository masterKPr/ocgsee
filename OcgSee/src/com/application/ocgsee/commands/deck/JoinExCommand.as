package com.application.ocgsee.commands.deck
{
	import com.application.ocgsee.proxys.DeckProxy;
	
	import mvclite.contorl.SimpleCommand_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class JoinExCommand extends SimpleCommand_Lite
	{
		public function JoinExCommand()
		{
			super();
		}
		public override function execute(notification:INotification):void{
			var card:Object=notification.getBody();
			var proxy:DeckProxy=appFacade.retrieveProxy_Lite(DeckProxy)as DeckProxy;
			proxy.joinEx(card);
		}
	}
}