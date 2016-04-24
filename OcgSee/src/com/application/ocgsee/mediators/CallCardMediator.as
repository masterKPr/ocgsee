package com.application.ocgsee.mediators
{
	import com.application.ApplicationFacade;
	import com.application.ocgsee.consts.CallEvents;
	import com.application.ocgsee.consts.GlobalNotifications;
	import com.application.ocgsee.proxys.AssetsProxy;
	import com.application.ocgsee.proxys.CardsTextureProxy;
	import com.application.ocgsee.proxys.ConfigProxy;
	import com.application.ocgsee.proxys.FavoritesSearchProxy;
	import com.application.ocgsee.proxys.GlobalProxy;
	import com.application.ocgsee.utils.localize;
	import com.application.ocgsee.views.mxml.ShowCard;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	
	import feathers.controls.Callout;
	
	import mvclite.mediator.Mediator_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.observer.Notification;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.formatString;
	
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
			notificationsProxy.regist(GlobalNotifications.SEARCH_SINGLE_COMPLETE,searchCompleteHandler);
			notificationsProxy.regist(CallEvents.HIDE_ONE_CARD,onHideCardHandler);
		}
		public override function setViewComponent(viewComponent:Object):void{
			super.setViewComponent(viewComponent);
			view.imgContent.addEventListener(TouchEvent.TOUCH,onImgTouch);
			
			view.copyBtn.addEventListener(Event.TRIGGERED,copyInfoHandler);
			view.saveBtn.addEventListener(Event.TRIGGERED,saveCardHandler);
		}
		private function onHideCardHandler(notification:Notification):void
		{
			if(callOut){
				view.imgContent.removeEventListener(TouchEvent.TOUCH,onImgTouch);
				view.copyBtn.removeEventListener(Event.TRIGGERED,copyInfoHandler);
				view.saveBtn.removeEventListener(Event.TRIGGERED,saveCardHandler);
				callOut.close(true);
				callOut=null;
				var globalProxy:GlobalProxy=appFacade.retrieveProxy_Lite(GlobalProxy)as GlobalProxy;
				globalProxy.showCard=false;
			}
		}
		
		private function searchCompleteHandler(notification:INotification):void
		{
			if(!view)return 
			var result:Array=notification.getBody() as Array;
			_cardVO=result[0];
			var isMonster:Boolean=_cardVO.type%2==1;
			if(isMonster){
				view.attributeLabel.text=createMonsterStr();
			}else{
				view.attributeLabel.text=createSpellStr();
			}
		}
		private function get configProxy():ConfigProxy{
			return ApplicationFacade._.retrieveProxy_Lite(ConfigProxy) as ConfigProxy;
		}
		
		
		private var monsterTemplate:String=String(
<root>
<![CDATA[{0}  ★{1}

{2}		{3}
ATK:{4}	DEF:{5}

{6}
{7}
]]></root>);
		
		private var spellTemplate:String=String(
<root>
<![CDATA[{0}
			
{1}

{2}
]]></root>);
		
		private function createSpellStr():String{
			var params:Array=[
				_cardVO.name,
				configProxy.getName("type",_cardVO.type),
				_cardVO.desc
			];
			params.unshift(spellTemplate);
			var str:String=formatString.apply(null,params);
			return str;
		}
		
		private function createMonsterStr():String{
			var __atkValue:String=formatValue(_cardVO.atk);
			var __defValue:String=formatValue(_cardVO.def);
			var params:Array=[
			_cardVO.name,
			_cardVO.level%16,
			configProxy.getName("attribute",_cardVO.attribute),
			configProxy.getName("race",_cardVO.race),
			__atkValue,
			__defValue,
			configProxy.getName("type",_cardVO.type),
			_cardVO.desc
			];
			params.unshift(monsterTemplate);
			var str:String=formatString.apply(null,params);
			return str;
		}
		
		private function formatValue(value:int):String{
			if(value==-2){
				return "?";
			}else{
				return ""+value;
			}
		}
		

		
		private function saveCardHandler(e:Event):void{
			var proxy:FavoritesSearchProxy=appFacade.retrieveProxy_Lite(FavoritesSearchProxy)as FavoritesSearchProxy;
			var stats:Boolean=proxy.hasOne(view.cardID);
			if(stats){
				proxy.delOne(view.cardID);
			}else{
				proxy.addOne(view.cardID);
			}
			view.btnContent.visible=!view.btnContent.visible;
		}
		private function copyInfoHandler(e:Event):void
		{
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
				if(proxy.hasOne(view.cardID)){
					view.saveBtn.label=localize("info_favorite_to_out");
				}else{
					view.saveBtn.label=localize("info_favorite_to_in");
				}
				view.btnContent.visible=!view.btnContent.visible;
			}
		}
		
		
		public function set cardID(value:int):void{
			var proxy:CardsTextureProxy=appFacade.retrieveProxy_Lite(CardsTextureProxy)as CardsTextureProxy;
			view.cardID=value;
			var globalProxy:GlobalProxy=appFacade.retrieveProxy_Lite(GlobalProxy)as GlobalProxy;
			var assets:AssetsProxy=appFacade.retrieveProxy_Lite(AssetsProxy)as AssetsProxy;
			
			var smartTexture:Texture=proxy.cardTextureLocal(value);
			smartTexture=smartTexture?smartTexture:assets.loadingTexture;
			view.image.loadingTexture=smartTexture;
			view.image.errorTexture=smartTexture;
			view.image.source=globalProxy.getRemoteUri(value);
		}
	}
}