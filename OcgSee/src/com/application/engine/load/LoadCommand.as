package com.application.engine.load
{
	
	import framework.log.LogUtils;
	
	import mvclite.contorl.SimpleCommand_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	
	
	public class LoadCommand extends SimpleCommand_Lite
	{
		public function LoadCommand()
		{
			super();
		}
		public override function execute(notification:INotification):void{
			
			var proxy:LoadProxy=appFacade.retrieveProxy_Lite(LoadProxy) as LoadProxy;
			var loadData:LoadData=proxy.getLoader(notification.getType());
			LogUtils.log(loadData.mediator)
			
//			sendNotification(pure_load,f);
			
			
			var f:Function=function():void{
				new loadData.mediator(new loadData.view);
			}
			
		}
	}
}