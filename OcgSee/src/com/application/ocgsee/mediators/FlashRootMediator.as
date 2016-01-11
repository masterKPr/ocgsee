package com.application.ocgsee.mediators
{
	import com.application.engine.utils.FileUtils;
	import com.application.ocgsee.StarlingRoot;
	import com.application.ocgsee.consts.GlobalEvents;
	import com.application.ocgsee.proxys.AssetsProxy;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	
	import mvclite.mediator.Mediator_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class FlashRootMediator extends Mediator_Lite
	{
		public var view:Sprite;
		
		private var _loadingLoader:Loader;
		
		private var _progressLabel:TextField;

		private var _loadingBackground:Bitmap;
		public function FlashRootMediator(viewComponent:Object=null)
		{
			super(viewComponent);
		}
		public override function onRegister():void{
			
			createLoadingImg();
			Starling.handleLostContext=true;
			var screenWidth:int  = appFacade.root.stage.fullScreenWidth;
			var screenHeight:int = appFacade.root.stage.fullScreenHeight;
			var __starling:Starling=new Starling(StarlingRoot,appFacade.root.stage,new Rectangle(0,0,screenWidth,screenHeight));
			
			__starling.addEventListener(Event.ROOT_CREATED,onStarlingCreate);
			
			__starling.start();
			__starling.showStats=true;
			
			//			__starling.enableErrorChecking=true;//错误检查
		}
		
		private function createLoadingImg():void
		{
			_loadingLoader=new Loader();
			var bytes:ByteArray=FileUtils.readFileBytes(File.applicationDirectory.resolvePath("Default-568h@2x.png"));
			_loadingLoader.loadBytes(bytes);
			_loadingLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadingImgComplete);
			
			_progressLabel=new TextField();
			var textformat:TextFormat=new TextFormat();
			textformat.align=TextFormatAlign.CENTER;
			textformat.size=60;
			textformat.color=0xff0000;
			//			_progressLabel.border=true;
			_progressLabel.defaultTextFormat=textformat;
			view.addChild(_progressLabel);
			_progressLabel.text="100%";
			_progressLabel.width=_progressLabel.textWidth+10;
			_progressLabel.height=_progressLabel.textHeight+10;
			_progressLabel.text="";
			
			var screenWidth:int  = appFacade.root.stage.fullScreenWidth;
			var screenHeight:int = appFacade.root.stage.fullScreenHeight;
			
			
			_progressLabel.x=(screenWidth-_progressLabel.width)/2;
			_progressLabel.y=(screenHeight-_progressLabel.height)/2;
			
		}
		
		protected function onLoadingImgComplete(e:*):void
		{
			var screenWidth:int  = appFacade.root.stage.fullScreenWidth;
			var screenHeight:int = appFacade.root.stage.fullScreenHeight;
			_loadingBackground=_loadingLoader.content as Bitmap;
			
			_loadingBackground.width=screenWidth;
			_loadingBackground.height=screenHeight;
			view.addChildAt(_loadingBackground,0);
			_loadingLoader.unloadAndStop();
			_loadingLoader=null;
		}
		protected override function registerNotification():void{
			notificationsProxy.regist(GlobalEvents.TEXTURE_COMPLETE,onTextureComplete);
			notificationsProxy.regist(GlobalEvents.LOADING_PROGRESS,refreshProgress);
		}
		
		private function refreshProgress(notification:INotification):void
		{
			var obj:Number=notification.getBody()as Number;
			var str:String=int(obj*100)+"%";
			_progressLabel.text=str;
		}
		
		private function onTextureComplete(notification:INotification):void
		{
			view.removeChild(_loadingBackground);
			var proxy:AssetsProxy=appFacade.retrieveProxy_Lite(AssetsProxy)as AssetsProxy;
			proxy.model.addTexture("fullScreen",Texture.fromBitmap(_loadingBackground));
			_loadingBackground=null;
			view.removeChild(_progressLabel);
			_progressLabel=null;
		}
		private function onStarlingCreate(e:Event):void
		{
			var root:StarlingRoot=e.data as StarlingRoot;
			facade.registerMediator(new StarlingMediator(root));
			
		}
	}
}