package mvclite.mediator
{
	import flash.utils.getQualifiedClassName;
	
	import mvclite.Facade_Lite;
	import mvclite.notification.LogEvents;
	import mvclite.unit.event.EventsProxy;
	import mvclite.unit.notification.NotificationsProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	
	public class Mediator_Lite extends Mediator
	{
		protected var notificationsProxy:NotificationsProxy
		protected var eventsProxy:EventsProxy
		
		public function Mediator_Lite(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			setViewDefault(viewComponent);
			createBaseProxy();  
			registerNotification();
		}
		private final function createBaseProxy():void{
			
			eventsProxy=new EventsProxy(this.NAME);
			facade.registerProxy(eventsProxy);
			
			notificationsProxy=new NotificationsProxy(this.NAME);
			facade.registerProxy(notificationsProxy);
		}
		/**
		 *NAME自动给定 如果出现同类中介器 改写该方法即可 
		 * @return 
		 * 
		 */		
		public function get NAME():String
		{
			return getQualifiedClassName(this);
		}
		
		/**
		 *使用 notificationsProxy.regist方法来注册notification
		 * listNotificationInterests和handleNotification弃用
		 */		
		protected function registerNotification():void{}
		
		/**
		 *回收操作的执行器 
		 * onRemove不在开放
		 */		
		protected function removeActuator():void{}
		
		public final override function listNotificationInterests():Array{
			return notificationsProxy.notifications;
		}
		public final override function handleNotification(notification:INotification):void{
			notificationsProxy.doNotification(notification);
		}
		public override final function onRemove():void{
			
			facade.removeProxy(notificationsProxy.NAME);
			facade.removeProxy(eventsProxy.NAME);
			
			removeActuator();
			super.onRemove();
		}
		private final function setViewDefault(view:Object):void{
			if(this.hasOwnProperty("view")&&view){
				this["view"]=view;
			}else{
				sendNotification(LogEvents.ERROR,this+"无法指定属性view");
			}
		}
		public override function setViewComponent(viewComponent:Object):void{
			setViewDefault(viewComponent);
			super.viewComponent=viewComponent;
		}
		public function get appFacade():Facade_Lite{
			return facade as Facade_Lite
		}
	}
}