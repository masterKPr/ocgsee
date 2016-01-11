package com.application.ocgsee.commands
{
	import com.application.engine.search.SearchEngine;
	import com.application.ocgsee.proxys.FavoritesSearchProxy;
	
	import flash.filesystem.File;
	
	import mvclite.contorl.SimpleCommand_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class InitFavoritesCommand extends SimpleCommand_Lite
	{
		public function InitFavoritesCommand()
		{
			super();
		}
		public override function execute(notification:INotification):void{
			var proxy:FavoritesSearchProxy=new FavoritesSearchProxy(new SearchEngine);
			appFacade.registerProxy(proxy);
			var db:File=File.applicationStorageDirectory.resolvePath("favorites.db");
			proxy.open(db);
			proxy.create();
			
		}
	}
}