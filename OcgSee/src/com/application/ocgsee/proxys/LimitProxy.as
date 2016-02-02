package com.application.ocgsee.proxys
{
	import com.application.ApplicationFacade;
	import com.application.engine.utils.FileUtils;
	import com.application.ocgsee.consts.GlobalNotifications;
	import com.application.ocgsee.consts.LimitConst;
	import com.application.ocgsee.models.LflistPackage;
	
	import flash.filesystem.File;
	
	import mvclite.proxys.Proxy_Lite;
	
	import starling.textures.Texture;
	
	
	
	public class LimitProxy extends Proxy_Lite
	{
		public var model:LflistPackage
		
		public function LimitProxy(data:Object=null)
		{
			super(data);
			update();
		}
		public var lflistDict:Object={};
		public function update():void{
			var fileDir:File=File.applicationStorageDirectory.resolvePath("lflist");
			fileDir.createDirectory();
			var fileList:Array=fileDir.getDirectoryListing();
			for each(var file:File in fileList){
				var str:String=FileUtils.readFile(file);
				var obj:Object=JSON.parse(str);
				lflistDict[obj.title]=obj;
			}
		}
		private var _selectLflist:String;
		
		public function get selectLflist():String
		{
			return ApplicationFacade._.kvdb.take("last_lflist");
		}
		
		public function set selectLflist(value:String):void
		{
			if(value!=selectLflist){
				_selectLflist = value;
				ApplicationFacade._.kvdb.save("last_lflist",value);
				sendNotification(GlobalNotifications.REFRESH_LFLIST);
			}
		}
		public function get currentLflist():LflistPackage{
			var obj:Object=lflistDict[selectLflist];
			model.parse(obj);
			return model;
		}
		
		
		
		public function getLimitMark(id:int):String{  
			if(currentLflist.forbidden.indexOf(id)!=-1){
				return LimitConst.FORBIDDEN;
			}else if(currentLflist.limit.indexOf(id)!=-1){ 
				return LimitConst.LIMIT;
			}else if(currentLflist.semiLimit.indexOf(id)!=-1){
				return LimitConst.SEMI_LIMIT;
			}else{
				return LimitConst.NO_LIMIT;
			}
		}
		public function getLimitMarkImg(id:int):Texture
		{
			var proxy:AssetsProxy=appFacade.retrieveProxy_Lite(AssetsProxy)as AssetsProxy;
			return proxy.systemTextures.getTexture(getLimitMark(id));
		}
		
	}
}