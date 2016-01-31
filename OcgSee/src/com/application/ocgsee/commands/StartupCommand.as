package com.application.ocgsee.commands
{
	import com.application.ocgsee.consts.GlobalNotifications;
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
			sendNotification(GlobalNotifications.INIT_FAVORITES);
			sendNotification(GlobalNotifications.OPEN_DB);
			sendNotification(GlobalNotifications.CHECK_LFLIST);
			facade.registerMediator(new FlashRootMediator(appFacade.root));
			
		}
	}
}