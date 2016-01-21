package com.application.ocgsee.proxys
{
	import com.application.engine.utils.FileUtils;
	import com.application.ocgsee.consts.LimitConst;
	import com.application.ocgsee.models.LflistPackage;
	
	import flash.filesystem.File;
	
	import mvclite.proxys.Proxy_Lite;
	
	import starling.textures.Texture;
	
	
	
	public class LimitProxy extends Proxy_Lite implements ILimit
	{
		public var model:LflistPackage;
		
		public function LimitProxy(data:Object=null)
		{
			super(data);
			init();
		}
		public var lflistDict:Object={};
		private function init():void{
			var fileDir:File=File.applicationStorageDirectory.resolvePath("lflist");
			var fileList:Array=fileDir.getDirectoryListing();
			for each(var file:File in fileList){
				var str:String=FileUtils.readFile(file);
				var obj:Object=JSON.parse(str);
				lflistDict[obj.title]=obj;
			}
		}
		public function get currentLflist():LflistPackage{
			if (!model){
				var assetsProxy:AssetsProxy=appFacade.retrieveProxy_Lite(AssetsProxy) as AssetsProxy;
				var obj:Object=assetsProxy.takeJSON("default_lflist");
				model=new LflistPackage();
				model.parse(obj);
			}
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