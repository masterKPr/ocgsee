package com.application.ocgsee.mediators
{
	import com.application.ocgsee.consts.GlobalNotifications;
	import com.application.ocgsee.views.LoginView;
	
	import flash.events.MouseEvent;
	
	import mvclite.mediator.Mediator_Lite;
	
	import org.puremvc.as3.patterns.observer.Notification;
	
	
	public class LoginMediator extends Mediator_Lite
	{
		public var view:LoginView;
		public function LoginMediator(viewComponent:Object=null)
		{
			super(viewComponent);
		}
		public override function onRegister():void{
//			eventsProxy.regist(view.button,MouseEvent.CLICK,onClick);
		}
		protected override function registerNotification():void{
//			notificationsProxy.addListener(Events.REFRESH_BTN_NAME,refreshHandler);
		}
		
		private function refreshHandler(notification:Notification):void
		{
//			var proxy:ButtonNameModelProxy=appFacade.retrieveProxy_Lite(ButtonNameModelProxy)as ButtonNameModelProxy;
//			view.button.label=proxy.GET::buttonName();
		}
		
		private function onClick(e:MouseEvent):void
		{
//			facade.sendNotification(Events.CHANGE_LABEL_NAME,"返回");
			facade.sendNotification(GlobalNotifications.LOAD_SOMETING,null,"xxx");
		}
		
	}
}