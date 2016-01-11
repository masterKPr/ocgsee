package framework.log
{
	import framework.FrameworkFacade;
	
	import mvclite.notification.LogEvents;

	public class LogUtils
	{
		public function LogUtils()
		{
		}
		public static function log(msg:*,type:String=""):void{
			FrameworkFacade.getFacade().sendNotification(LogEvents.LOG,msg,type);
		}
		public static function error(msg:*,type:String=""):void{
			FrameworkFacade.getFacade().sendNotification(LogEvents.ERROR,msg,type);
		}
		public static function debug(msg:*,type:String=""):void{
			FrameworkFacade.getFacade().sendNotification(LogEvents.DEBUG,msg,type);
		}
		public static function warn(msg:*,type:String=""):void{
			FrameworkFacade.getFacade().sendNotification(LogEvents.WARN,msg,type);
		}
	}
}