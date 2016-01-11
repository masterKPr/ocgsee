package com.application.ocgsee.proxys
{
	import com.application.ocgsee.consts.DeckEvents;
	import com.application.ocgsee.models.DeckPackage;
	
	import mvclite.proxys.Proxy_Lite;
	
	public class DeckProxy extends Proxy_Lite
	{
		public var model:DeckPackage;
		public function DeckProxy(data:Object=null)
		{
			super(data);
		}
		public function joinMain(card:Object):void{
			model.mainDeck.push(card);
			facade.sendNotification(DeckEvents.REFRESH_MAIN);
		}
		public function joinSide(card:Object):void{
			model.sideDeck.push(card);
			facade.sendNotification(DeckEvents.REFRESH_SIDE);
		}
		public function joinEx(card:Object):void{
			model.exDeck.push(card);
			facade.sendNotification(DeckEvents.REFRESH_EX);
		}
		public function getMain():Array{
			return model.mainDeck;
		}
		public function getSide():Array{
			return model.sideDeck;
		}
		public function getEx():Array{
			return model.exDeck;
		}
	}
}