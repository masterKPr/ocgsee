package mvclite.commands
{
	import mvclite.contorl.SimpleCommand_Lite;
	import mvclite.notification.MVCLiteEvents;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class LogCommand_Lite extends SimpleCommand_Lite
	{
		public function LogCommand_Lite()
		{
			super();
		}
		public override function execute(notification:INotification):void{
			var msg:*=notification.getBody();
			var title:String=notification.getType();
			if(!title){
				title=MVCLiteEvents.USER;
			}
			var log_type:String=notification.getName();
			trace(log_type+":",title,"->",msg);
		}
	}
}