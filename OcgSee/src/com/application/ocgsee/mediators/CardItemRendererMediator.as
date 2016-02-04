package com.application.ocgsee.mediators
{
	import com.application.ApplicationFacade;
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
	import starling.utils.formatString;
	
	public class CardItemRendererMediator extends Mediator_Lite
	{
		private var index:int;
		private static var createIndex:int;
		public var view:CardItemRenderer;
		public function CardItemRendererMediator(viewComponent:Object=null)
		{
			index=createIndex;
			createIndex++;
			LogUtils.log(formatString("创建个数:{0}",createIndex));
			super(viewComponent);
			view.loadingAndError=assetsProxy.loadingTexture;
			view.selectedTexture=assetsProxy.selectedTexture;
		}
		public override function get NAME():String{
			return getQualifiedClassName(this)+index;
		}
		protected override function registerNotification():void{
			notificationsProxy.regist(GlobalNotifications.REFRESH_CARD_TEXTURE,refreshCardTexture);
			notificationsProxy.regist(GlobalNotifications.GC_DISPOSE,gcDispose);
			notificationsProxy.regist(GlobalNotifications.REFRESH_LFLIST,refreshLflistMark);
		}
		
		private function gcDispose(notification:INotification):void
		{
			if(!view.data){
				return;
			}
			var obj:Object=notification.getBody();
			var id:int=obj.id;
			if(view.data.id==id)
			{
				view.cardSource=cardsTextures.cardTexture(id);
			}
		}
		private function get cardsTextures():CardsTextureProxy{
			return appFacade.retrieveProxy_Lite(CardsTextureProxy) as CardsTextureProxy;
		}
		public override function onRegister():void{
			eventsProxy.regist(view,GlobalEvents.DISPOSE,onDispose);
			eventsProxy.regist(view,CardItemRenderer.DATA_CHANGE,onDataRefresh);
			eventsProxy.regist(view,Event.CHANGE,onSelectChange);
		}
		private function delayCall():void{
			facade.sendNotification(CallEvents.CALL_ONE_CARD,{target:view,id:view.data.id});
		}
		private function onSelectChange(e:Event):void
		{
			if(view.isSelected)
			{
				Starling.current.juggler.delayCall(delayCall,0.0001);
			}
			else
			{
				facade.sendNotification(CallEvents.HIDE_ONE_CARD);
			}
		}
		
		private function get limitProxy():LimitProxy{
			return appFacade.retrieveProxy_Lite(LimitProxy) as LimitProxy;
		}
		private function get assetsProxy():AssetsProxy{
			return appFacade.retrieveProxy_Lite(AssetsProxy) as AssetsProxy;
		}
		private function onDataRefresh(e:Event):void{
			
			if(view.data)
			{
				var __id:int=view.data.id;
				view.cardSource=cardsTextures.cardTexture(__id);
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
				view.newMarkSource=null;
			}
			refreshLflistMark(null);
		}
		
		private function onDispose(e:Event):void
		{
			LogUtils.log("销毁Mediator:"+this);
			appFacade.removeMediator(NAME);
		}
		private function refreshLflistMark(notification:INotification):void{
			var litmitSource:Texture;
			if(view.data)
			{
				litmitSource=limitProxy.getLimitMarkImg(view.data.id);
			}
			view.limitSource=litmitSource;
		}
		private function refreshCardTexture(notification:INotification):void
		{
			if(!view.data){
				return;
			}
			var obj:Object=notification.getBody();
			var id:int=obj.id;
			if(view.data.id==id)
			{
				view.cardSource=ImageCache._.takeID(id);
			}
		}
	}
}