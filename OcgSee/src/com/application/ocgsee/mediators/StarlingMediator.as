package com.application.ocgsee.mediators
{
	
	import com.application.ocgsee.StarlingRoot;
	import com.application.ocgsee.consts.GlobalEvents;
	import com.application.ocgsee.proxys.AssetsProxy;
	import com.application.ocgsee.proxys.LoaderProxy;
	import com.application.ocgsee.themes.OcgseeTheme;
	import com.application.ocgsee.views.ResultListView;
	import com.application.ocgsee.views.SearchView;
	
	import flash.utils.setTimeout;
	
	import feathers.controls.Drawers;
	import feathers.events.FeathersEventType;
	
	import framework.log.LogUtils;
	
	import mvclite.mediator.Mediator_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import starling.display.Image;
	import starling.events.Event;
	
	
	public class StarlingMediator extends Mediator_Lite
	{
		public var view:StarlingRoot;
		
		public function StarlingMediator(viewComponent:Object=null)
		{
			super(viewComponent);
		}
		public override function onRegister():void{
			new OcgseeTheme()
			LogUtils.log("starling start");
			facade.registerMediator(new CallCardMediator());
			var loaderProxy:LoaderProxy=appFacade.retrieveProxy_Lite(LoaderProxy) as LoaderProxy;
			loaderProxy.begin();
			sendNotification(GlobalEvents.CHECK_DB);

		}
		
		
		protected override function registerNotification():void{
			notificationsProxy.regist(GlobalEvents.RES_COMPLETE,onTextureComplete);
		}
		
		private function onTextureComplete(notification:INotification):void
		{
			createView();
		}
		
		private function createView():void
		{
			var resultList:ResultListView=new ResultListView();
			facade.registerMediator(new ResultListMediator(resultList));
			
			var searchView:SearchView=new SearchView();
			facade.registerMediator(new SearchViewMediator(searchView));
			
//			var setterView:SetterView=new SetterView();
//			facade.
			//			var deckView:DeckView=new DeckView();
			//			facade.registerMediator(new DeckMediator(deckView));
			view.drawers=new Drawers();
			
			var proxy:AssetsProxy=appFacade.retrieveProxy_Lite(AssetsProxy)as AssetsProxy;
			
			var image:Image=new Image(proxy.model.getTexture("fullScreen"));
//			
			view.addChild(view.drawers);
			view.drawers.openGesture = Drawers.OPEN_GESTURE_DRAG_CONTENT_EDGE;
			view.drawers.content = resultList
			view.drawers.leftDrawer=searchView;
			view.drawers.overlaySkin=image;
			
			eventsProxy.regist(view.drawers,FeathersEventType.BEGIN_INTERACTION,beginInteractHandler);
			eventsProxy.regist(view.drawers,FeathersEventType.END_INTERACTION,endInteractHandler);
			eventsProxy.regist(view.drawers,Event.OPEN,openHandler);
			eventsProxy.regist(view.drawers,Event.CLOSE,closeHandler);
			
			//			_drawers.rightDrawer=deckView;
		}
		
		private function openHandler(e:Event):void
		{
			sendNotification(GlobalEvents.DRAWERS_OPEN);
		}
		
		private function closeHandler(e:Event):void
		{
			sendNotification(GlobalEvents.DRAWERS_CLOSE);
		}
		
		private function endInteractHandler(e:Event):void
		{
			sendNotification(GlobalEvents.DRAWERS_STOP_INTERACTION);
		}
		
		private function beginInteractHandler(e:Event):void
		{
			sendNotification(GlobalEvents.DRAWERS_BEGIN_INTERACTION);
		}
	}
}