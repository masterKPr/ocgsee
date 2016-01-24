package com.application.ocgsee.mediators
{
	import com.application.ApplicationFacade;
	import com.application.engine.interfaces.ICardTexture;
	import com.application.ocgsee.consts.GlobalEvents;
	import com.application.ocgsee.proxys.AssetsProxy;
	import com.application.ocgsee.proxys.CardsTextureProxy;
	import com.application.ocgsee.proxys.LimitProxy;
	import com.application.ocgsee.utils.ImageCache;
	import com.application.ocgsee.views.CardItemRenderer;
	
	import flash.utils.getQualifiedClassName;
	
	import mvclite.mediator.Mediator_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class CardRendererMediator extends Mediator_Lite
	{
		private var index:int;
		private static var createIndex:int;
		public var view:CardItemRenderer;
		public function CardRendererMediator(viewComponent:Object=null)
		{
			index=createIndex;
			createIndex++;
			super(viewComponent);
			var assets:AssetsProxy=appFacade.retrieveProxy_Lite(AssetsProxy)as AssetsProxy;
			view.cardImage.loadingTexture=assets.loadingTexture;
			view.cardImage.errorTexture=assets.loadingTexture;
		}
		public override function get NAME():String{
			return getQualifiedClassName(this)+index;
		}
		protected override function registerNotification():void{
			notificationsProxy.regist(GlobalEvents.REFRESH_CARD_TEXTURE,refreshCardTexture);
			notificationsProxy.regist(GlobalEvents.GC_DISPOSE,gcDispose);
			notificationsProxy.regist(GlobalEvents.REFRESH_LFLIST,refreshLflist);
		}
		
		private function gcDispose(notification:INotification):void
		{
			var obj:Object=notification.getBody();
			var id:int=obj.id;
			if(view.data.id==id){
				view.cardImage.source=cardsTextures.cardTexture(id);
			}
		}
		private function get cardsTextures():ICardTexture{
			return appFacade.retrieveProxy_Lite(CardsTextureProxy) as CardsTextureProxy;
		}
		public override function onRegister():void{
			eventsProxy.regist(view,GlobalEvents.DISPOSE,onDispose);
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
				view.cardImage.source=ImageCache._.takeID(id);
			}
		}
	}
}