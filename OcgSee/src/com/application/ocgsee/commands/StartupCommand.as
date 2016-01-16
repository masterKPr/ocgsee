package com.application.ocgsee.commands
{
	import com.application.ocgsee.consts.GlobalEvents;
	import com.application.ocgsee.mediators.FlashRootMediator;
	
	import mvclite.contorl.SimpleCommand_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class StartupCommand extends SimpleCommand_Lite
	{
		public function StartupCommand()
		{
			super();
		}
		public override function execute(notification:INotification):void{
			sendNotification(GlobalEvents.INIT_FAVORITES);
			sendNotification(GlobalEvents.OPEN_DB);
			facade.registerMediator(new FlashRootMediator(appFacade.root));
			
		}
	}
}