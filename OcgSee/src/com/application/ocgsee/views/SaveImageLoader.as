package com.application.ocgsee.views
{
	import com.application.ApplicationFacade;
	import com.application.engine.utils.FileUtils;
	import com.application.ocgsee.consts.GlobalNotifications;
	import com.application.ocgsee.proxys.GlobalProxy;
	import com.application.ocgsee.utils.ImageCache;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import feathers.controls.ImageLoader;
	
	import framework.log.LogUtils;
	
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.formatString;
	
	public class SaveImageLoader extends ImageLoader
	{
		private static var map:ImageCache=ImageCache._;
		public function SaveImageLoader()
		{
			this.addEventListener(starling.events.Event.IO_ERROR,onIOError);
			super();
		}
		private function onIOError(e:starling.events.Event):void
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
			return ApplicationFacade._.globalProxy;
		}
		protected override function loader_completeHandler(event:flash.events.Event):void{
			
			var bitmap:Bitmap = Bitmap(this.loader.content);
			if(this.source is String){
				var url:String=this.source as String;
				//				this.
				var cardJPG:String=globalProxy.getCardJPG(url);
				if(globalProxy.isRemoteUri(url)){
					saveLocal(url,bitmap.bitmapData.clone());
				}
				var texture:Texture=Texture.fromBitmapData(bitmap.bitmapData.clone());
				map.save(cardJPG,texture);
				var obj:Object={
					id:globalProxy.get_ID_CardJPG(cardJPG)
				};
				
			}else{
				LogUtils.warn(formatString("不是string的加载类型:{0}",this.source));
			}
			super.loader_completeHandler(event);
			if(this.source is String){//迁移SDK 底层事件机制修改后 延时刷新界面
				ApplicationFacade._.sendNotification(GlobalNotifications.REFRESH_CARD_TEXTURE,obj);
			}
		}
	}
}