package com.application.ocgsee.proxys
{
	import com.application.ocgsee.consts.LimitConst;
	import com.application.ocgsee.models.LfListModel;
	import com.application.ocgsee.models.LflistPackage;
	import com.application.ocgsee.utils.DecodeLflist;
	
	
	import mvclite.proxys.Proxy_Lite;
	
	import starling.textures.Texture;
	
	
	
	public class LimitProxy extends Proxy_Lite implements ILimit
	{
		public var model:LfListModel;
		
		public function LimitProxy(data:Object=null)
		{
			super(data);
		}
		public function get currentLflist():LflistPackage{				
			if (!model.LflistList){
				var assetsProxy:AssetsProxy=appFacade.retrieveProxy_Lite(AssetsProxy) as AssetsProxy;
				var str:String=assetsProxy.takeUTF("lflist");
				model.LflistList=DecodeLflist.getConfig(str);
			}
			return model.LflistList[0];
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