package com.application 
{
	import com.application.engine.load.LoadCommand;
	import com.application.engine.load.LoadModel;
	import com.application.engine.load.LoadProxy;
	import com.application.engine.local.LocaleProxy;
	import com.application.engine.search.SearchEngine;
	import com.application.ocgsee.commands.ActiveCommand;
	import com.application.ocgsee.commands.CallCardInfoCommand;
	import com.application.ocgsee.commands.CheckDBCommand;
	import com.application.ocgsee.commands.DeactiveCommand;
	import com.application.ocgsee.commands.InitFavoritesCommand;
	import com.application.ocgsee.commands.InitializeDBCommand;
	import com.application.ocgsee.commands.SearchCommand;
	import com.application.ocgsee.commands.StartupCommand;
	import com.application.ocgsee.commands.deck.JoinExCommand;
	import com.application.ocgsee.commands.deck.JoinMainCommand;
	import com.application.ocgsee.commands.deck.JoinSideCommand;
	import com.application.ocgsee.consts.CallEvents;
	import com.application.ocgsee.consts.DeckEvents;
	import com.application.ocgsee.consts.GlobalEvents;
	import com.application.ocgsee.mediators.LoginMediator;
	import com.application.ocgsee.models.DeckPackage;
	import com.application.ocgsee.models.GlobalModel;
	import com.application.ocgsee.models.LfListModel;
	import com.application.ocgsee.models.SQLText;
	import com.application.ocgsee.proxys.AssetsProxy;
	import com.application.ocgsee.proxys.CardsSearchProxy;
	import com.application.ocgsee.proxys.CardsTextureProxy;
	import com.application.ocgsee.proxys.DeckProxy;
	import com.application.ocgsee.proxys.GlobalProxy;
	import com.application.ocgsee.proxys.LimitProxy;
	import com.application.ocgsee.proxys.LoaderProxy;
	import com.application.ocgsee.proxys.SQLProxy;
	import com.application.ocgsee.views.LoginView;
	
	import framework.FrameworkFacade;
	import framework.events.MVCFrameworkEvents;
	
	import mvclite.notification.MVCLiteEvents;
	
	import starling.utils.AssetManager;
	
	public class ApplicationFacade extends FrameworkFacade
	{
		public function ApplicationFacade()
		{
			super();
		}
		public static function get _():ApplicationFacade{
			if( instance == null) instance = new ApplicationFacade(); 
			return instance as ApplicationFacade; 
		}

		private var _globalProxy:GlobalProxy;
		public function get globalProxy():GlobalProxy{
			return _globalProxy;
		}
		
		private var _localeProxy:LocaleProxy;
		public function get locale():LocaleProxy{
			return _localeProxy;
		}

		protected override function initializeController():void{
			super.initializeController();
			
			registerCommand(MVCFrameworkEvents.START_UP,StartupCommand);
			registerCommand(GlobalEvents.LOAD_SOMETING,LoadCommand);
			registerCommand(MVCLiteEvents.ACTIVE,ActiveCommand);
			registerCommand(MVCLiteEvents.DEACTIVE,DeactiveCommand);
			registerCommand(GlobalEvents.SEARCH,SearchCommand);
			registerCommand(CallEvents.CALL_ONE_CARD,CallCardInfoCommand);
			registerCommand(DeckEvents.JOIN_MAIN,JoinMainCommand);
			registerCommand(DeckEvents.JOIN_SIDE,JoinSideCommand);
			registerCommand(DeckEvents.JOIN_EX,JoinExCommand);
			registerCommand(GlobalEvents.INIT_FAVORITES,InitFavoritesCommand);
			registerCommand(GlobalEvents.CHECK_DB,CheckDBCommand);
			registerCommand(GlobalEvents.INIT_DB,InitializeDBCommand);
			
			
		}
		
		protected override function initializeModel():void{
			super.initializeModel();
			_globalProxy=new GlobalProxy(new GlobalModel)
			registerProxy(_globalProxy);
			registerProxy(new LoadProxy(new LoadModel));
			registerProxy(new CardsSearchProxy(new SearchEngine));
			registerProxy(new SQLProxy(new SQLText));
			
			var appAssets:AssetManager=new AssetManager();
			appAssets.verbose=false;
			
			registerProxy(new AssetsProxy(appAssets));
			registerProxy(new CardsTextureProxy(appAssets));
			_localeProxy=new LocaleProxy(appAssets);
			registerProxy(_localeProxy);
			registerProxy(new LoaderProxy(appAssets));
			
			registerProxy(new DeckProxy(new DeckPackage));
			registerProxy(new LimitProxy(new LfListModel));
			initializeLoadMap();
		}
		
		
		private function initializeLoadMap():void
		{
			var proxy:LoadProxy=retrieveProxy_Lite(LoadProxy) as LoadProxy;
			proxy.registLoader("xxx",LoginMediator,LoginView);
		}
		protected override function initializeView():void{
			super.initializeView();
		}
	}
}