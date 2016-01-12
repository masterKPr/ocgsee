package framework.preset.commands
{
	import com.demonsters.debugger.MonsterDebugger;
	
//	import mvclite.LogCommand_Lite;
//	import mvclite.commands.LogCommand_Lite;
	import mvclite.contorl.SimpleCommand_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	
	
	public class LogCommand extends SimpleCommand_Lite
	{
		public function LogCommand()
		{
			super();
		}
		public override function execute(notification:INotification):void{
//			new LogCommand_Lite().execute(notification);
			var msg:*=notification.getBody();
			MonsterDebugger.trace(this,msg,notification.getType(),notification.getName());
//			if(SystemUtil.platform!="WIN"){
//				trace(msg);
//			}
			trace(notification.getName(),notification.getType(),msg);
		}
	}
}