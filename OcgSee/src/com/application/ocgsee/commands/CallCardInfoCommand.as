package com.application.ocgsee.commands
{
	import com.application.ocgsee.consts.GlobalNotifications;
	import com.application.ocgsee.mediators.CallCardMediator;
	import com.application.ocgsee.proxys.GlobalProxy;
	import com.application.ocgsee.proxys.SQLProxy;
	import com.application.ocgsee.views.mxml.ShowCard;
	
	import feathers.controls.Callout;
	import feathers.controls.renderers.IListItemRenderer;
	
	import mvclite.contorl.SimpleCommand_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import starling.display.DisplayObject;
	
	public class CallCardInfoCommand extends SimpleCommand_Lite
	{
		
		public function CallCardInfoCommand()
		{
			super();
		}
		public override function execute(notification:INotification):void{
			var prams:Object=notification.getBody();
			var target:IListItemRenderer=prams["target"];
			if(target.isSelected==false){
				return;
			}
			var id:int=prams["id"];
			var screenWidth:int  = appFacade.root.stage.fullScreenWidth-20;
			
			var content:ShowCard=new ShowCard();
			content.scale=screenWidth/431;
			
			var mediator:CallCardMediator=appFacade.retrieveMediator_Lite(CallCardMediator)as CallCardMediator;
			
			mediator.setViewComponent(content);
			mediator.cardID=id;
			var callOut:Callout=Callout.show(content,target as DisplayObject,"any",false);
			mediator.callOut=callOut;
			var globalProxy:GlobalProxy=appFacade.retrieveProxy_Lite(GlobalProxy)as GlobalProxy;
			globalProxy.showCard=true;
			var proxy:SQLProxy=appFacade.retrieveProxy_Lite(SQLProxy) as SQLProxy;
			var text:String=proxy.singleCardSQL(id);
			sendNotification(GlobalNotifications.SEARCH_SINGLE,text);
			
			
			
		}
	}
}