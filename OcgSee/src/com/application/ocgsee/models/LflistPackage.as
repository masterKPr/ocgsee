package com.application.ocgsee.models
{
	public class LflistPackage
	{
		public var title:String;
		public var forbidden:Array=[];//禁止
		public var limit:Array=[];//限制
		public var semiLimit:Array=[];//准限制
		public function LflistPackage()
		{
		}
		public function parse(obj:Object):void{
			this.forbidden=obj["forbidden"];
			this.limit=obj["limit"];
			this.semiLimit=obj["semi limit"];
			this.title=obj["title"];
		}
	}
}