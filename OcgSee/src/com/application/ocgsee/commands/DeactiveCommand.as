package com.application.ocgsee.commands
{
	import mvclite.contorl.SimpleCommand_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import starling.core.Starling;
	
	public class DeactiveCommand extends SimpleCommand_Lite
	{
		public function DeactiveCommand()
		{
			super();
		}
		public override function execute(notification:INotification):void{
			Starling.current.stop();
		}
	}
}