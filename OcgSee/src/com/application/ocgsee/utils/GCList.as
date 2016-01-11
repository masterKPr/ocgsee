package com.application.ocgsee.utils
{
	public class GCList
	{
		private var _len:int;
		private var _list:Array=[];
		public function GCList(len:int)
		{
			this._len=len;
		}
		public function push(key:String):String{
			var re:String=null;
			var __index:int=_list.indexOf(key);
			if(__index!=-1){
				var sp:Array=_list.splice(__index,1);
				var target:String=sp[0];
				_list.push(target);
			}else{
				_list.push(key);
			}
			if(_list.length>_len){
				var del:String=_list.shift();
				re=del;
			}
			return re;
		}
	}
}