package mvclite.proxys
{
	import mvclite.Facade_Lite;
	import mvclite.notification.LogEvents;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	
	public class AbstractProxy extends Proxy
	{
		public function AbstractProxy(name:String,data:Object=null)
		{
			super(name, data);
			setModelDefault(data);
		}
		public override function setData(data:Object):void{
			setModelDefault(data);
			super.setData(data);
		}
		public function get NAME():String
		{
			sendNotification(LogEvents.ERROR,"Abstract方法");
			return null;
		}
		private final function setModelDefault(data:Object):void{
			if(this.hasOwnProperty("model")&&data){
				this["model"]=data;
			}else{
				sendNotification(LogEvents.ERROR,this+"无法指定属性model");
			}
		}
		public function get appFacade():Facade_Lite{
			return facade as Facade_Lite
		}
	}
}