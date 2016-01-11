package mvclite.unit.event
{
	
	
	
	import mvclite.notification.LogEvents;
	import mvclite.proxys.Proxy_Name;
	
	
	public class EventsProxy extends Proxy_Name
	{
		public var model:EventsModel;
		public function EventsProxy(mediatorName:String)
		{
			super(mediatorName, new EventsModel);
		}
		public function regist(dispatcher:*,event:String,handler:Function):void{
			if(hasListener(dispatcher,event,handler)){
				sendNotification(LogEvents.WARN,dispatcher+"注册过"+event+"事件了");
			}else{
				var listenerSet:IListenerData=new ListenerData().init(dispatcher,event,handler);
				model.list.push(listenerSet);
			}
		}
		public function remove(dispatcher:*,event:String,handler:Function):Boolean{
			var __re:Boolean;
			for(var i:int=0;i<model.list.length;i++){
				var listenerSet:ListenerData=model.list[i];
				if(listenerSet.dispatcher==dispatcher&&
					listenerSet.event==event&&
					listenerSet.handler==handler){
					__re=true;
					listenerSet.remove();
					model.list.splice(i, 1);
					break;
				}
			}
			return __re;
		}
		private function removeAll():void{
			while(model.list.length){
				var listenerSet:ListenerData=model.list.pop();
				listenerSet.remove();
			}
		}
		public override function onRemove():void{
			removeAll();
			model=null;
			super.onRemove();
		}
		public function hasListener(dispatcher:*,event:String,handler:Function):Boolean{
			var __re:Boolean;
			for(var i:int=0;i<model.list.length;i++){
				var listenerSet:ListenerData=model.list[i];
				if(listenerSet.dispatcher==dispatcher&&
					listenerSet.event==event&&
					listenerSet.handler==handler){
					__re=true;
					break;
				}
			}
			return __re;
		}
	}
}