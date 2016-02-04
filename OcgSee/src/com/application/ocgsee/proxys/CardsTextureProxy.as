package com.application.ocgsee.proxys
{
	import com.application.ocgsee.utils.ImageCache;
	
	import mvclite.proxys.Proxy_Lite;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	public class CardsTextureProxy extends Proxy_Lite
	{
		private static const length:int=11;
		public function CardsTextureProxy(data:Object=null)
		{
			super(data);
		}
		public var model:AssetManager
		/**
		 *  
		 * @param id
		 * @return 有贴图返回贴图 没贴图的时候返回远程地址
		 * 
		 */		
		public function cardTexture(id:int):*{
			var re:*=cardTextureLocal(id);
			var __api:String=globalProxy.getRemoteUri(id);
			var __cardJPG:String=globalProxy.getCardJPG(__api);
			var loaded:Boolean=ImageCache._.has(__cardJPG);
			if(loaded){
				re=ImageCache._.take(__cardJPG);
			}
			if(!re){
				re=__api;
			}
			return re
		}
		
		public function cardTextureLocal(id:int):*
		{
			var index:int=id%length;
			var atlas:TextureAtlas=model.getTextureAtlas("CardsTexture_"+index);
			var target:Texture=atlas.getTexture(""+id);
			return target;
		}
		public function get globalProxy():GlobalProxy{
			return appFacade.retrieveProxy_Lite(GlobalProxy)as GlobalProxy;
		}
		
	}
}