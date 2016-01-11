package com.application.engine.search
{
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.utils.ByteArray;
	
	public class SearchEngine extends SQLStatement
	{
		public var connection:SQLConnection
		public function SearchEngine()
		{
			init();
		}
		private function init():void{
			connection=new SQLConnection();
			this.sqlConnection=connection;
		}
		public  function open(reference:Object=null, openMode:String="create", autoCompact:Boolean=false, pageSize:int=1024, encryptionKey:ByteArray=null):void{
			if(connection.connected){
				connection.close();
			}
			connection.open(reference,openMode,autoCompact,pageSize,encryptionKey);
		}
		
	}
}