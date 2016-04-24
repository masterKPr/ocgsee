package com.application.ocgsee.proxys
{
	import com.application.engine.search.SearchEngine;
	
	import flash.data.SQLResult;
	import flash.utils.ByteArray;
	
	import mvclite.proxys.Proxy_Lite;
	
	import starling.utils.formatString;
	
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
			var template:String="create table if not exists {0} (id INTEGER primary key)";
			excecute(formatString(template,TABLE_NAME));
		}
		public function addOne(id:int):void{
			var template:String="insert into {0} values({1})";
			excecute(formatString(template,TABLE_NAME,id));
			mark=true;
		}
		public function delOne(id:int):void{
			var template:String="delete from {0} where id={1}";
			excecute(formatString(template,TABLE_NAME,id));
			mark=true;
		}
		public function hasOne(id:int):Boolean{
			var template:String="select id from {0} where id={1}";
			excecute(formatString(template,TABLE_NAME,id));
			var result:SQLResult=model.getResult();
			var list:Array=result.data;
			if(!list){
				list=[];
			}
			return Boolean(list.length);
		}
		public function getAll():Array{
			
			if(mark)
			{
				var template:String="select id from {0}";
				excecute(formatString(template,TABLE_NAME));
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