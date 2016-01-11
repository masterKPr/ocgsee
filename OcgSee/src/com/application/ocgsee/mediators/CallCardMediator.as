package com.application.ocgsee.mediators
{
	import com.application.engine.utils.FileUtils;
	import com.application.ocgsee.consts.CallEvents;
	import com.application.ocgsee.consts.GlobalEvents;
	import com.application.ocgsee.consts.SearchType;
	import com.application.ocgsee.proxys.AssetsProxy;
	import com.application.ocgsee.proxys.CardsTextureProxy;
	import com.application.ocgsee.proxys.FavoritesSearchProxy;
	import com.application.ocgsee.proxys.GlobalProxy;
	import com.application.ocgsee.views.ShowCard;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.filesystem.File;
	import flash.media.CameraRoll;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	
	import feathers.controls.Callout;
	
	import mvclite.mediator.Mediator_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.observer.Notification;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class CallCardMediator extends Mediator_Lite
	{
		public var view:ShowCard;
		
		private var _cardVO:Object;


		
		public var callOut:Callout;
		public function CallCardMediator(viewComponent:Object=null)
		{
			super(viewComponent);
		}
		protected override function registerNotification():void{
			notificationsProxy.regist(GlobalEvents.SEARCH_COMPLETE,searchCompleteHandler);
			notificationsProxy.regist(CallEvents.HIDE_ONE_CARD,onHideCardHandler);
		}
		
		private function onHideCardHandler(notification:Notification):void
		{
			if(callOut){
				callOut.close(true);
				callOut=null;
				var globalProxy:GlobalProxy=appFacade.retrieveProxy_Lite(GlobalProxy)as GlobalProxy;
				globalProxy.model.showCard=false;
			}
		}
		
		private function searchCompleteHandler(notification:INotification):void
		{
			if(!view)return 
			if(notification.getType()==SearchType.SINGLE){
				var result:Array=notification.getBody() as Array;
				_cardVO=result[0];
				var isMonster:Boolean=_cardVO.type%2==1;
				if(isMonster){
					view.attributeLabel.text=createMonsterStr();
				}else{
					view.attributeLabel.text=createSpellStr();
				}
				
				
			}
		}
		private function createSpellStr():String{
			var re:String="";
			re+=_cardVO.name;
			re+="\n\n"+getName("type",_cardVO.type)+"\n\n";
			re+=_cardVO.desc;
			return re;
		}
		private function createMonsterStr():String{
			var re:String="";
			re+=_cardVO.name;
			var __atkValue:String=formatValue(_cardVO.atk);
			var __defValue:String=formatValue(_cardVO.def);
			
			re+="  "+"★"+_cardVO.level%16+"\n\n"
			re+=getName("attribute",_cardVO.attribute)+"\t\t";
			re+=getName("race",_cardVO.race)+"\n";
			var atkStr:String="ATK:"+__atkValue
			re+=addSpace(atkStr);
			re+="\t";
			re+="DEF:"+__defValue
			re+="\n\n";
			re+=getName("type",_cardVO.type)+"\n";
			re+=_cardVO.desc;
			return re;
		}
		private function formatValue(value:int):String{
			if(value==-2){
				return "?";
			}else{
				return ""+value;
			}
		}
		private function addSpace(str:String):String{
			while(str.length<8){
				str+=" ";
			}
			return str;
		}
		private var _config:XML;
		public function get config():XML{
			if(!_config){
				var assetsProxy:AssetsProxy=appFacade.retrieveProxy_Lite(AssetsProxy) as AssetsProxy;
				_config=assetsProxy.takeXML("Label_Config");
			}
			return _config;
		}
		public override function setViewComponent(viewComponent:Object):void{
			super.setViewComponent(viewComponent);
			view.imgContent.addEventListener(TouchEvent.TOUCH,onImgTouch);
			
			view.copyBtn.addEventListener(Event.TRIGGERED,copyInfoHandler);
			view.saveBtn.addEventListener(Event.TRIGGERED,saveCardHandler);
			view.backBtn.addEventListener(Event.TRIGGERED,backHandler);
		}
		
		private function backHandler(e:Event):void
		{
			view.btnContent.visible=!view.btnContent.visible;
		}
		private function saveCardHandler(e:Event):void{
			var proxy:FavoritesSearchProxy=appFacade.retrieveProxy_Lite(FavoritesSearchProxy)as FavoritesSearchProxy;
			var stats:Boolean=proxy.hasOne(view.id);
			if(stats){
				proxy.delOne(view.id);
			}else{
				proxy.addOne(view.id);
			}
			view.btnContent.visible=!view.btnContent.visible;
		}
		private function copyInfoHandler(e:Event):void
		{
//			var db:String=File.applicationStorageDirectory.resolvePath("favorites.db").nativePath;
//			var file:FileReference=new FileReference();
//			file.save(db);
	
//			var url:URLRequest=new URLRequest("mailto:525398535@qq.com?body="+view.attributeLabel.text+"&attach="+db);
//			navigateToURL(url);
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,view.attributeLabel.text);
			view.btnContent.visible=!view.btnContent.visible;
		}
		
		private function onBtnTouch(e:Event):void
		{
//			sendNotification(DeckEvents.JOIN_SIDE,clone(_cardVO));
		}
		public function clone(object:Object):Object{
			var new_one:Object={};
			for(var key:String in object){
				new_one[key]=object[key];
			}
			return new_one;
		}
		
		private function onImgTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(view.imgContent, TouchPhase.ENDED);
			if(touch){
				var proxy:FavoritesSearchProxy=appFacade.retrieveProxy_Lite(FavoritesSearchProxy)as FavoritesSearchProxy;
				if(proxy.hasOne(view.id)){
					view.saveBtn.label="收藏 ★"
				}else{
					view.saveBtn.label="收藏 ☆"
				}
				view.btnContent.visible=!view.btnContent.visible;
			}
		}
		
		private function getName(itemId:String,childId:String):String{
			var str:String= config.item.(@id==itemId).child.(@id==childId)[0];
			if(str=="0"){
				return childId;
			}else{
				return str;
			}
		}
		public function set id(value:int):void{
			var proxy:CardsTextureProxy=appFacade.retrieveProxy_Lite(CardsTextureProxy)as CardsTextureProxy;
			view.id=value;
			var globalProxy:GlobalProxy=appFacade.retrieveProxy_Lite(GlobalProxy)as GlobalProxy;
			var assets:AssetsProxy=appFacade.retrieveProxy_Lite(AssetsProxy)as AssetsProxy;
			
			var smartTexture:Texture=proxy.cardTextureLocal(value);
			smartTexture=smartTexture?smartTexture:assets.loadingTexture;
			view.netImage.loadingTexture=smartTexture;
			view.netImage.errorTexture=smartTexture;
			view.netImage.source=globalProxy.getMyCardUri(value);
		}
	}
}