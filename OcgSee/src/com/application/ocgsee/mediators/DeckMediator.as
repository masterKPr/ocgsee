package com.application.ocgsee.mediators
{
	import com.application.ocgsee.consts.DeckEvents;
	import com.application.ocgsee.proxys.DeckProxy;
	import com.application.ocgsee.proxys.AssetsProxy;
	import com.application.ocgsee.views.CardItemRenderer;
	import com.application.ocgsee.views.DeckView;
	import com.application.engine.ApplicationMediator;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	import feathers.layout.VerticalLayout;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import starling.events.Event;
	
	public class DeckMediator extends ApplicationMediator
	{
		public var view:DeckView;
		public function DeckMediator(viewComponent:Object=null)
		{
			super(viewComponent);
		}
		public override function onRegister():void{
			createView();
			refreshMain(null);
		}
		
		
		private function createView():void
		{
			var screenWidth:int  = appFacade.root.stage.fullScreenWidth;
			var viewList:Array=[view.mainList,view.sideList,view.exList];
			view.width=screenWidth-20;
			var itemRendererFactory:Function=function():IListItemRenderer{
				var item:CardItemRenderer//=new CardItemRenderer;
				item.cardsTextures=proxy;
				item.facade=appFacade;
				return item;
			}
			
			for each(var list:List in viewList){

				list.width=screenWidth-40;
				var listLayout:TiledRowsLayout = new TiledRowsLayout();
				listLayout.useSquareTiles = false;
				listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
				listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
				listLayout.padding = 0;
				listLayout.gap = 4;
//				listLayout.paddingRight=20;
				listLayout.horizontalGap=-40;
				list.layout=listLayout;
				list.itemRendererFactory=itemRendererFactory;
			}
			
			view.mainList.height=(CardItemRenderer.HEIGHT+4)*4;
			view.sideList.height=CardItemRenderer.HEIGHT+4;
			view.exList.height=CardItemRenderer.HEIGHT+4;
			
			
			var proxy:AssetsProxy=appFacade.retrieveProxy_Lite(AssetsProxy) as AssetsProxy; 
			

			//			listLayout.horizontalGap=-40;
			//			listLayout.verticalGap=10;
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign=VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			layout.gap=10;
//			layout.paddingTop=50;
			view.layout = layout;
			
		}
		protected override function registerNotification():void{
			notificationsProxy.regist(DeckEvents.REFRESH_MAIN,refreshMain);
			notificationsProxy.regist(DeckEvents.REFRESH_SIDE,refreshSide);
			notificationsProxy.regist(DeckEvents.REFRESH_EX,refreshEx);
		}
		
		private function refreshMain(notification:INotification):void
		{
			var proxy:DeckProxy=appFacade.retrieveProxy_Lite(DeckProxy) as DeckProxy;
			view.mainList.dataProvider=new ListCollection(proxy.getMain());
		}
		private function refreshSide(notification:INotification):void
		{
			var proxy:DeckProxy=appFacade.retrieveProxy_Lite(DeckProxy) as DeckProxy;
			view.sideList.dataProvider=new ListCollection(proxy.getSide());
		}
		private function refreshEx(notification:INotification):void
		{
			var proxy:DeckProxy=appFacade.retrieveProxy_Lite(DeckProxy) as DeckProxy;
			view.exList.dataProvider=new ListCollection(proxy.getEx());
		}
	}
}