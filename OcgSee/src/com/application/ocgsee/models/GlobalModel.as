package com.application.ocgsee.models
{

	public class GlobalModel
	{
		public const PICS_API:String=SERVER_HEAD+"pics/{0}.jpg";
		public const SERVER_HEAD:String="http://ocgsee.applinzi.com/";
		public var showCard:Boolean;
		public var drawOpen:Boolean;
		
		public function GlobalModel()
		{
		}
	}
}