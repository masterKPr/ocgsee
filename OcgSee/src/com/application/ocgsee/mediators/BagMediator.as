package com.application.ocgsee.mediators
{
	import com.application.ocgsee.consts.CallEvents;
	import com.application.ocgsee.consts.CardConst;
	import com.application.ocgsee.consts.GlobalNotifications;
	import com.application.ocgsee.models.CardsAnalysis;
	import com.application.ocgsee.proxys.AssetsProxy;
	import com.application.ocgsee.proxys.GlobalProxy;
	import com.application.ocgsee.utils.CardSortUtils;
	import com.application.ocgsee.views.CardItemRenderer;
	import com.application.ocgsee.views.BagView;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	
	import mvclite.mediator.Mediator_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.observer.Notification;
	
	import starling.events.Event;
	
	
	public class BagMediator extends Mediator_Lite
	{
		public var view:BagView;
		
		public function BagMediator(viewComponent:Object=null)
		{
			super(viewComponent);
		}
		public override function onRegister():void{
			createView();
			eventsProxy.regist(view.resultList,Event.SCROLL,onListScroll);
			
		}
		
		private function onListScroll(e:Event):void
		{
			view.resultList.selectedIndex=-1;
		}
		protected override function registerNotification():void{
			notificationsProxy.regist(GlobalNotifications.SEARCH_MULIT_COMPLETE,searchCompleteHandler);
			
			notificationsProxy.regist(GlobalNotifications.DRAWERS_BEGIN_INTERACTION,onDrawersControlBegin);
			
			notificationsProxy.regist(GlobalNotifications.DRAWERS_OPEN,onDrawerOpen);
			notificationsProxy.regist(GlobalNotifications.DRAWERS_CLOSE,onDrawerClose);
			notificationsProxy.regist(GlobalNotifications.RESULT_LAYOUT_CHANGE,onLayoutChange);
		}
		
		private function onLayoutChange(notification:INotification):void
		{
			var value:int=notification.getBody()as int;
			view.resultList.itemRendererFactory=createRendererFactory(value);
		}
		public function createRendererFactory(value:int):Function{
			var gap:int=4;
			var screenWidth:int  = appFacade.root.stage.fullScreenWidth;
			var scale:Number=64/93;
			var obset:Number=(value-3)*0.4;
			var cardWidth:int=screenWidth/value-gap*2-1+obset;
			var cardHeight:Number=cardWidth/scale;
			var assetsProxy:AssetsProxy=appFacade.retrieveProxy_Lite(AssetsProxy) as AssetsProxy;
			var f:Function=function():IListItemRenderer{
				var item:CardItemRenderer=new CardItemRenderer(cardWidth,cardHeight);
				var meditator:CardItemRendererMediator=new CardItemRendererMediator(item);
				appFacade.registerMediator(meditator);
				return item
			}
			return f;
		}
		
		
		private function onDrawerClose(notification:Notification):void
		{
			view.unflatten();
			var globalProxy:GlobalProxy=appFacade.retrieveProxy_Lite(GlobalProxy)as GlobalProxy;
			globalProxy.isDrawOpen=false;
		}
		
		private function onDrawerOpen(notification:Notification):void
		{
			view.flatten();
			
		}
		
		private function onDrawersControlBegin(notification:Notification):void
		{
			var globalProxy:GlobalProxy=appFacade.retrieveProxy_Lite(GlobalProxy)as GlobalProxy;
			globalProxy.isDrawOpen=true;
			view.resultList.stopScrolling();
			sendNotification(CallEvents.HIDE_ONE_CARD);
		}
		
		private function searchCompleteHandler(notification:INotification):void
		{
			var result:Array=notification.getBody() as Array;
			var _analysis:CardsAnalysis=new CardsAnalysis(result);
			view.label.text=_analysis.text;
			//应该直接有个分析类 getString方法 返回分析结果
			var fields:Array=[CardConst.MONSTER_LEVEL,CardConst.ATK];
			var options:Array=[Array.NUMERIC|Array.DESCENDING,Array.NUMERIC|Array.DESCENDING];
			var sortList:Array=CardSortUtils.sortCardList(result,fields,options);
			view.resultList.dataProvider=new ListCollection(sortList);
		}
		private function formatCards(list:Array):Array{
			for each(var item:Object in list){
				item[CardConst.MONSTER_LEVEL]=item.level&0xf;
			}
			return list;
		}
		
		private function createView():void
		{
			var screenWidth:int  = appFacade.root.stage.fullScreenWidth;
			var screenHeight:int = appFacade.root.stage.fullScreenHeight;
			view.resultList.width=	screenWidth-40;
			view.resultList.height=	screenHeight-40;
			view.labelContent.width=screenWidth-40;
			
			var listLayout:TiledRowsLayout = new TiledRowsLayout();
			//			listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;//滑动方向
			listLayout.useSquareTiles = false;
			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.padding = 0;
			listLayout.requestedColumnCount=8;
			var gap:int=4;
			listLayout.gap = gap;
			//			listLayout.horizontalGap=-40;
			//			listLayout.verticalGap=10;
			
			//			listLayout.paddingLeft=0
			view.resultList.layout=listLayout;
			
			view.resultList.itemRendererFactory=createRendererFactory(4)
		}
	}
}