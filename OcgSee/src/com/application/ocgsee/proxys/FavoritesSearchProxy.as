package com.application.ocgsee.proxys
{
	import com.application.engine.search.SearchEngine;
	
	import flash.data.SQLResult;
	import flash.utils.ByteArray;
	
	import mvclite.proxys.Proxy_Lite;
	
	public class FavoritesSearchProxy extends Proxy_Lite
	{
		public var model:SearchEngine;
		public function FavoritesSearchProxy(data:Object=null)
		{
			super(data);
		}
		public  function open(reference:Object=null, openMode:String="create", autoCompact:Boolean=false, pageSize:int=1024, encryptionKey:ByteArray=null):void{
			if(model.connection.connected){
				model.connection.close();
			}
			model.connection.open(reference,openMode,autoCompact,pageSize,encryptionKey);
		}
		public function excecute(text:String):void{
			model.text=text;
			model.execute();
		}
		private const TABLE_NAME:String="cards";
		private var mark:Boolean=true;

		private var _lastAll:Array;
		public function create():void{
			excecute("create table if not exists "+TABLE_NAME+" (id INTEGER primary key)");
		}
		public function addOne(id:int):void{
			excecute("insert into "+TABLE_NAME+" values("+id+")");
			mark=true;
		}
		public function delOne(id:int):void{
			excecute("delete from "+TABLE_NAME+" where id="+id);
			mark=true;
		}
		public function hasOne(id:int):Boolean{
			excecute("select id from "+TABLE_NAME+" where id="+id)
			var result:SQLResult=model.getResult();
			var list:Array=result.data;
			if(!list){
				list=[];
			}
			return list.length;
		}
		public function getAll():Array{
			
			if(mark)
			{
				excecute("select id from "+TABLE_NAME);
				var result:SQLResult=model.getResult();
				var list:Array=result.data;
				if(!list){
					list=[];
				}
				var re:Array=[];
				for each(var obj:Object in list){
					re.push(obj.id);
				}
				_lastAll=re;
				mark=false;
			}else{
				 re=_lastAll;
			}
			return re;
		}
		
	}
}