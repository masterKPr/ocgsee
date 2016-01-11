package framework
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import framework.events.MVCFrameworkEvents;
	import framework.preset.commands.LogCommand;
	
	import mvclite.Facade_Lite;
	import mvclite.notification.LogEvents;
	import mvclite.notification.MVCLiteEvents;
	
	public class FrameworkFacade extends Facade_Lite
	{
		private static var _facade:FrameworkFacade
		/**
		 *当前框架下最后一个被实例化的FrameworkFacade 并非单例! 引用可能为空 不自动初始化用于框架下其他部件的使用
		 * @return 
		 * 
		 */		
		public static function getFacade():FrameworkFacade{
			if(!_facade){
				throw new Error("FrameworkFacade还未初始化");
			}
			return _facade;
		}
		public function FrameworkFacade()
		{
			_facade=this;
			super();
		}
		protected final override function startupHandler():void{
			MonsterDebugger.initialize(this.root);//把start事件移到这里
			sendNotification(MVCFrameworkEvents.START_UP);
		}
		protected override function initializeController():void{
			super.initializeController();
			registerCommand(LogEvents.LOG,LogCommand);
			registerCommand(LogEvents.WARN,LogCommand);
			registerCommand(LogEvents.DEBUG,LogCommand);
			registerCommand(LogEvents.ERROR,LogCommand);
		}
	}
}