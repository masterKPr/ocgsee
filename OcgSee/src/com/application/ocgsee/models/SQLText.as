package com.application.ocgsee.models
{
	public class SQLText
	{
		public const FIELD_VALUE:String=" datas.id,datas.type,datas.atk,datas.def,datas.level,datas.attribute,datas.ot,datas.race,texts.name ";
		public const SEARCH_RESULT_HEAD:String="select" + FIELD_VALUE + "from datas,texts where datas.id=texts.id";
		
		
		public const FIELD_ALL:String=	" datas.id,datas.type,datas.atk,datas.def,datas.level,datas.attribute,datas.ot,datas.race,texts.name,texts.desc ";
		public const SEARCH_SINGLE_HEAD:String="select " + FIELD_ALL+"from datas,texts where datas.id=texts.id and datas.id=";
		
		
		public function SQLText()
		{
		}
	}
}