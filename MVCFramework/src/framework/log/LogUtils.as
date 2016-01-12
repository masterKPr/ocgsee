package framework.log
{
	import framework.FrameworkFacade;
	
	import mvclite.notification.LogEvents;
	import mvclite.notification.MVCLiteEvents;

	public class LogUtils
	{
		public function LogUtils()
		{
		}
		public static function log(msg:*,type:String=MVCLiteEvents.USER):void{
			report(LogEvents.LOG,msg,type);
		}
		public static function error(msg:*,type:String=MVCLiteEvents.USER):void{
			report(LogEvents.ERROR,msg,type);
		}
		public static function debug(msg:*,type:String=MVCLiteEvents.USER):void{
			report(LogEvents.DEBUG,msg,type);
		}
		public static function warn(msg:*,type:String=MVCLiteEvents.USER):void{
			report(LogEvents.WARN,msg,type);
		}
		private static function report(logType:String,msg:*,type:String):void{
			FrameworkFacade.getFacade().sendNotification(logType,msg,type);
		}
	}
}