package mvclite.unit.event
{
	

	public class ListenerData implements IListenerData{
		
		private var _dispatcher:*;
		private var _event:String;
		private var _handler:Function;

		public function get handler():Function
		{
			return _handler;
		}

		public function set handler(value:Function):void
		{
			_handler = value;
		}

		public function get event():String
		{
			return _event;
		}

		public function set event(value:String):void
		{
			_event = value;
		}

		public function get dispatcher():*
		{
			return _dispatcher;
		}

		public function set dispatcher(value:*):void
		{
			_dispatcher = value;
		}


		
		public function init(dispatcher:*,event:String,handler:Function):IListenerData{
			this.dispatcher=dispatcher;
			this.event=event;
			this.handler=handler;
			dispatcher.addEventListener(event,handler);
			return this;
		}
		public function remove():void{
			dispatcher.removeEventListener(event,handler);
			this.dispatcher=null;
			this.event=null;
			this.handler=null;
		}
	}
}