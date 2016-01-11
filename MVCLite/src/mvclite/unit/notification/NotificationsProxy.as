package mvclite.unit.notification
{
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import mvclite.notification.LogEvents;
	import mvclite.proxys.Proxy_Name;
	
	
	public class NotificationsProxy extends Proxy_Name
	{
		public var model:NotificationsModel
		
		public function NotificationsProxy(mediatorName:String)
		{
			super(mediatorName, new NotificationsModel);
		}
		private var _changeMark:Boolean;
		public function regist(msg:String,handler:Function):void{
			if(model.hasOwnProperty(msg)){
				sendNotification(LogEvents.WARN,"已经存在这个事件侦听"+msg);
			}else{
				_changeMark=true;
			}
			model.dict[msg]=handler;
		}
		public function removeListener(msg:String):void{
			if(model.dict.hasOwnProperty(msg)){
				delete model.dict[msg];
				_changeMark=true;
			}
		}
		private function removeAll():void{
			model.dict=new Dictionary();
			_changeMark=true;
		}
		public override function onRemove():void{
			removeAll();
			model=null;
			super.onRemove();
		}
		private function refreshNotifications():Array{
			var __re:Array=[];
			for(var key:String in model.dict){
				__re.push(key);
			}
			return __re;
		}
		public function get notifications():Array{
			if(_changeMark){
				model.lastNotifications=refreshNotifications();
				_changeMark=false;
			}
			return model.lastNotifications;
		}
		public function doNotification(not:INotification):void{
			var handler:Function=model.dict[not.getName()];
			handler.apply(null,[not]);
		}
	}
}