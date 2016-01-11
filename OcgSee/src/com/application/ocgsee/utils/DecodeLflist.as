package com.application.ocgsee.utils
{
	import com.application.ocgsee.models.LflistPackage;
	
	
	
	public class DecodeLflist
	{

		public function DecodeLflist()
		{
		}
		public static function getConfig(lflistStr:String):Array{
			var configList:Array=lflistStr.split("!");
			var returnConfigList:Array=[];
			for(var i:uint=1;i<configList.length;i++){
				var vo:LflistPackage=new LflistPackage();
				var singleConfig:String=configList[i];
				var temp:Array=singleConfig.split("#forbidden");
				vo.title=temp[0];
				vo.title=vo.title.split("\n").join("");
				temp=String(temp[1]).split("#limit");
				var unList:String=temp[0];
				vo.forbidden=getIdList(unList," 0 --");
				temp=String(temp[1]).split("#semi limit");
				var oneList:String=temp[0];
				vo.limit=getIdList(oneList," 1 --");
				var twoList:String=temp[1];
				vo.semiLimit=getIdList(twoList," 2 --");
				returnConfigList.push(vo);
			}
			var noLflist:LflistPackage=new LflistPackage();
			noLflist.title="无卡表";
			returnConfigList.push(noLflist);
			return returnConfigList;
		}
		public static function getIdList(value:String,key:String):Array{
//			MonsterDebugger.trace("valueStr",value);
			var list:Array=value.split("\n");
			var idList:Array=[];
			for(var i:uint=0;i<list.length;i++){
				var idAndName:String=list[i];
				var keyList:Array=idAndName.split(key);
				if(keyList.length==2){
					idList.push(int(keyList[0]));
				}
			}
			return idList;
		}
	}
}