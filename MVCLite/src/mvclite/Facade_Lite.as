package mvclite
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import mvclite.commands.LogCommand_Lite;
	import mvclite.mediator.Mediator_Lite;
	import mvclite.notification.MVCLiteEvents;
	import mvclite.notification.LogEvents;
	import mvclite.proxys.Proxy_Lite;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class Facade_Lite extends Facade
	{
		public var root:Sprite;
		public function Facade_Lite()
		{
			super();
		}
		public final function startup(root:Sprite):void{
			this.root=root;
			root.addEventListener(Event.ACTIVATE,onActivate);
			root.addEventListener(Event.DEACTIVATE,onDeactivate);
			startupHandler();
		}
		protected function startupHandler():void{
			
		}
		protected function onActivate(event:Event):void
		{
			sendNotification(LogEvents.LOG,Event.ACTIVATE,MVCLiteEvents.SYSTEM);
			sendNotification(MVCLiteEvents.ACTIVE);
		}
		protected function onDeactivate(event:Event):void
		{
			sendNotification(LogEvents.LOG,Event.DEACTIVATE,MVCLiteEvents.SYSTEM);
			sendNotification(MVCLiteEvents.DEACTIVE);
		}
		public function retrieveProxy_Lite(proxyClass:Class):Proxy_Lite{
			return retrieveProxy(getQualifiedClassName(proxyClass)) as Proxy_Lite;
		}
		public function retrieveMediator_Lite(proxyClass:Class):Mediator_Lite{
			return retrieveMediator(getQualifiedClassName(proxyClass)) as Mediator_Lite;
		}
		protected override function initializeController():void{
			super.initializeController();
			registerCommand(LogEvents.LOG,LogCommand_Lite);
			registerCommand(LogEvents.WARN,LogCommand_Lite);
			registerCommand(LogEvents.DEBUG,LogCommand_Lite);
			registerCommand(LogEvents.ERROR,LogCommand_Lite);
		}
	}
}