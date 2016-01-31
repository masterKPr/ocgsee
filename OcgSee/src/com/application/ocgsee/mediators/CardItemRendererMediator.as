package com.application.ocgsee.mediators
{
	import com.application.ApplicationFacade;
	import com.application.engine.interfaces.ICardTexture;
	import com.application.ocgsee.consts.CallEvents;
	import com.application.ocgsee.consts.GlobalEvents;
	import com.application.ocgsee.consts.GlobalNotifications;
	import com.application.ocgsee.proxys.AssetsProxy;
	import com.application.ocgsee.proxys.CardsTextureProxy;
	import com.application.ocgsee.proxys.LimitProxy;
	import com.application.ocgsee.utils.ImageCache;
	import com.application.ocgsee.utils.localize;
	import com.application.ocgsee.views.CardItemRenderer;
	
	import flash.utils.getQualifiedClassName;
	
	import framework.log.LogUtils;
	
	import mvclite.mediator.Mediator_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class CardItemRendererMediator extends Mediator_Lite
	{
		private var index:int;
		private static var createIndex:int;
		public var view:CardItemRenderer;
		public function CardItemRendererMediator(viewComponent:Object=null)
		{
			index=createIndex;
			createIndex++;
			LogUtils.log("创建个数:"+createIndex);
			super(viewComponent);
			var assets:AssetsProxy=appFacade.retrieveProxy_Lite(AssetsProxy)as AssetsProxy;
			view.loadingAndError=assets.loadingTexture;
		}
		public override function get NAME():String{
			return getQualifiedClassName(this)+index;
		}
		protected override function registerNotification():void{
			notificationsProxy.regist(GlobalNotifications.REFRESH_CARD_TEXTURE,refreshCardTexture);
			notificationsProxy.regist(GlobalNotifications.GC_DISPOSE,gcDispose);
			notificationsProxy.regist(GlobalNotifications.REFRESH_LFLIST,refreshLflist);
		}
		
		private function gcDispose(notification:INotification):void
		{
			var obj:Object=notification.getBody();
			var id:int=obj.id;
			if(view.data.id==id){
				view.cardSource=cardsTextures.cardTexture(id);
			}
		}
		private function get cardsTextures():ICardTexture{
			return appFacade.retrieveProxy_Lite(CardsTextureProxy) as CardsTextureProxy;
		}
		public override function onRegister():void{
			eventsProxy.regist(view,GlobalEvents.DISPOSE,onDispose);
			eventsProxy.regist(view,CardItemRenderer.DATA_CHANGE,ondataRefresh);
			eventsProxy.regist(view,Event.CHANGE,onSelectChange);
		}
		
		private function onSelectChange(e:Event):void
		{
			if(view.isSelected){
				var f:Function=function():void{
					facade.sendNotification(CallEvents.CALL_ONE_CARD,{target:view,id:view.data.id});
				}
				Starling.current.juggler.delayCall(f,0.0001);
			}else{
				facade.sendNotification(CallEvents.HIDE_ONE_CARD);
			}
		}
		
		private function get limitProxy():LimitProxy{
			return appFacade.retrieveProxy_Lite(LimitProxy) as LimitProxy;
		}
		private function get assetsProxy():AssetsProxy{
			return appFacade.retrieveProxy_Lite(AssetsProxy) as AssetsProxy;
		}
		private function ondataRefresh(e:Event):void{
			if(view.data)
			{
				var __id:int=view.data.id;
				view.cardSource=cardsTextures.cardTexture(__id);
				view.limitSource=limitProxy.getLimitMarkImg(__id);
				var __isNew:Boolean=ApplicationFacade._.globalProxy.isNewCard(__id);
				if(__isNew)
				{
					view.newMarkSource=assetsProxy.newCardTexture;
				}
				else
				{
					view.newMarkSource=null;
				}
				
				if(view.data.ot==1)
				{
					view.setLabel(localize("card_ot_1_simple"),0x0000ff);
				}
				else if(view.data.ot==2)
				{
					view.setLabel(localize("card_ot_2_simple"),0xff0000);
				}
				else
				{
					view.setLabel("",0)
				}
			}
			else
			{
				view.cardSource=null;
				view.limitSource=null;
				view.newMarkSource=null;
			}
		}
		
		private function onDispose(e:Event):void
		{
			appFacade.removeMediator(NAME);
		}
		private function refreshLflist(notification:INotification):void{
			var limitProxy:LimitProxy=ApplicationFacade._.retrieveProxy_Lite(LimitProxy) as LimitProxy;
			var litmitSource:Texture;
			if(view.data){
				litmitSource=limitProxy.getLimitMarkImg(view.data.id);
			}
			view.limitSource=litmitSource;
		}
		private function refreshCardTexture(notification:INotification):void
		{
			var obj:Object=notification.getBody();
			var id:int=obj.id;
			if(view.data.id==id){
				view.cardSource=ImageCache._.takeID(id);
			}
		}
	}
}