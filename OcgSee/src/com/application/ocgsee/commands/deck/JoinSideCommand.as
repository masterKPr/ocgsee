package com.application.ocgsee.commands.deck
{
	import com.application.ocgsee.proxys.DeckProxy;
	
	import mvclite.contorl.SimpleCommand_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class JoinSideCommand extends SimpleCommand_Lite
	{
		public function JoinSideCommand()
		{
			super();
		}
		public override function execute(notification:INotification):void{
			var card:Object=notification.getBody();
			var proxy:DeckProxy=appFacade.retrieveProxy_Lite(DeckProxy)as DeckProxy;
			proxy.joinSide(card);
		}
	}

}