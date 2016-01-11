package com.application.ocgsee.models.assets
{
	import starling.events.Event;
	
	public class ProgressEvent extends Event
	{
		public static const PROGRESS:String="PROGRESS";
		public var progress:Number;
		public function ProgressEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			progress=data as Number;
			super(type, bubbles, data);
		}
	}
}