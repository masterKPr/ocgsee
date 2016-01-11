package mvclite.unit.event
{

	public interface IListenerData
	{
		function set dispatcher(value:*):void
		function get dispatcher():*
		function set event(value:String):void
		function get event():String;
		function set handler(value:Function):void
		function get handler():Function
		function init(dispatcher:*,event:String,handler:Function):IListenerData
		function remove():void
	}
}