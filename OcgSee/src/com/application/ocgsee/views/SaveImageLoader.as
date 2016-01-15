package com.application.ocgsee.views
{
	import com.application.ApplicationFacade;
	import com.application.engine.utils.FileUtils;
	import com.application.ocgsee.consts.GlobalEvents;
	import com.application.ocgsee.proxys.GlobalProxy;
	import com.application.ocgsee.utils.ImageCache;
	
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import feathers.controls.ImageLoader;
	
	import framework.log.LogUtils;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class SaveImageLoader extends ImageLoader
	{
		private static var map:ImageCache=ImageCache._;
		public function SaveImageLoader()
		{
			this.addEventListener(Event.COMPLETE,onLoaderComplete);
			this.addEventListener(IOErrorEvent.IO_ERROR,onIOerror);
			super();
		}
		private function onIOerror(e:IOErrorEvent):void
		{
			LogUtils.error(e);
		}
		public override function set source(value:Object):void{
			if(value is String){
				var sourcePath:String=String(value);
				var cardJPG:String=globalProxy.getCardJPG(sourcePath);
				var localFile:File=globalProxy.get_File_CardJPG(cardJPG);
				if(map.has(cardJPG)){
					LogUtils.log("ram");
					super.source=map.take(cardJPG);
				}else if(localFile.exists){
					super.source=localFile.url;
					LogUtils.log("local",localFile.nativePath);
					
				}else{
					super.source=value;
				}
			}else{
				super.source=value;
			}
		}
		private function saveLocal(httpURI:String,bitmapData:BitmapData):void{
			
			var cardJPG:String=globalProxy.getCardJPG(httpURI);
			var localFile:File=globalProxy.get_File_CardJPG(cardJPG);
			var bytes:ByteArray=bitmapData.encode(bitmapData.rect,new JPEGEncoderOptions(90));
			FileUtils.writeFileBytes(localFile,bytes);
		}
		private function get globalProxy():GlobalProxy{
			return ApplicationFacade._.globalProxy
		}
		private function onLoaderComplete(e:Event):void
		{
			if(this.source is String ){
				var url:String=this.source as String;
				var cardJPG:String=globalProxy.getCardJPG(url);
				if(globalProxy.isMCCardUri(url)){
					saveLocal(url,this._textureBitmapData);
				}
				var texture:Texture=Texture.fromBitmapData(this._textureBitmapData.clone());
				map.save(cardJPG,texture);
				var obj:Object={
					id:globalProxy.get_ID_CardJPG(cardJPG)
				};
				ApplicationFacade._.sendNotification(GlobalEvents.REFRESH_CARD_TEXTURE,obj);
			}else{
				LogUtils.warn("不是string的加载类型"+this.source);
			}
		}
		
	}
}