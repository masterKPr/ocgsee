package com.application.ocgsee.proxys
{
	
	import flash.utils.ByteArray;
	
	import mvclite.proxys.Proxy_Lite;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	public class AssetsProxy extends Proxy_Lite 
	{
		

		public var model:AssetManager;
		
		public function AssetsProxy(data:Object=null)
		{
			super(data);
		}
		public function get selectTexture():Texture{
			return systemTextures.getTexture("ground");
		} 
		public function get loadingTexture():Texture{
			return systemTextures.getTexture("unloading");
		} 
		public function get systemTextures():TextureAtlas{
			return model.getTextureAtlas("systemTexture"); 
		}
		public function takeUTF(name:String):String{ 
			var bytes:ByteArray=model.getByteArray(name);
			bytes.position=0; 
			return bytes.readUTFBytes(bytes.length);
		}
		public function takeXML(name:String):XML{
			return model.getXml(name);
		}
		
	}
}