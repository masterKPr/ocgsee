package mvclite.contorl
{
	import mvclite.Facade_Lite;
	
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SimpleCommand_Lite extends SimpleCommand
	{
		public function SimpleCommand_Lite()
		{
			super();
		}
		public function get appFacade():Facade_Lite{
			return facade as Facade_Lite
		}
	}
}