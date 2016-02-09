package com.application.ocgsee.mediators
{
	import com.application.ApplicationFacade;
	import com.application.ocgsee.consts.GlobalNotifications;
	import com.application.ocgsee.models.LflistPackage;
	import com.application.ocgsee.proxys.ConfigProxy;
	import com.application.ocgsee.proxys.FavoritesSearchProxy;
	import com.application.ocgsee.proxys.LimitProxy;
	import com.application.ocgsee.proxys.SQLProxy;
	import com.application.ocgsee.utils.localize;
	import com.application.ocgsee.views.mxml.LabelPicker;
	import com.application.ocgsee.views.mxml.SearchView;
	
	import feathers.data.ListCollection;
	
	import mvclite.mediator.Mediator_Lite;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import starling.events.Event;
	
	public class SearchViewMediator extends Mediator_Lite
	{
		public var view:SearchView;
		public function SearchViewMediator(viewComponent:Object=null)
		{
			super(viewComponent);
		}
		public override function onRegister():void{
			eventsProxy.regist(view,Event.ADDED_TO_STAGE,viewAddedHandler);
			
			eventsProxy.regist(view,SearchView.SEARCH,fullSearchHandler);
			eventsProxy.regist(view,SearchView.LAYOUT,layoutChangeHandler);
			eventsProxy.regist(view,SearchView.RESET,resetHandler);
			
		}
		
		
		private function layoutChangeHandler(e:Event):void
		{
			appFacade.sendNotification(GlobalNotifications.RESULT_LAYOUT_CHANGE,view.layoutStepper.value);
		}
		protected override function registerNotification():void{
			notificationsProxy.regist(GlobalNotifications.UPDATE_LFLIST,updateLflist);
			
		}
		
		private function updateLflist(notification:INotification):void
		{
			createLflistPicker();
		}
		private function viewAddedHandler(e:Event):void
		{
			createView();
			eventsProxy.remove(view,Event.ADDED_TO_STAGE,viewAddedHandler);
			fullSearchHandler(null);
		}
		private function pureSearch():void
		{
			if(isPause)return;
			if(view.isZero){
				view.resetBtn.label=localize("info_reset");
			}else{
				view.resetBtn.label="●"+localize("info_reset");
			}
			sendNotification(GlobalNotifications.SEARCH_MULIT,createSearchText());
		}
		
		private function createSearchText():String{
			var result:String=createSerchByLflist();
			for(var i:int=0;i<view.pickerList.length;i++){
				var picker:LabelPicker=view.pickerList[i];
				if(picker.selectedItem){
					result+=getRealTextPart(picker.selectedItem.value);
				}
			}
			result+=createSerchByTextInput();
			result+=createTokenToggle();
			result+=createFavorites();
			var proxy:SQLProxy=appFacade.retrieveProxy_Lite(SQLProxy) as SQLProxy;
			return proxy.createTermsSQL(result);
		}
		
		private function createTokenToggle():String
		{
			var value:Boolean=view.tokenPicker.isSelected;
			var str:String;
			if (value)
			{
				str="";
			}
			else
			{
				str=" and datas.type!=16401";
			}
			return str;
		}
		
		private function createSerchByTextInput():String
		{
			var value:String=view.searchInput.text;
			var str:String;
			if (value == "")
			{
				str="";
			}
			else
			{
				str=" and ( texts.name like '%" + value + "%' or texts.desc like '%" + value + "%' or datas.id='"+value+"')"
			}
			return str;
		}
		
		private function getRealTextPart(value:String):String{
			var re:String="";
			if(value.indexOf(" and ")==-1&&value!=""){
				re=" and "+value;
			}else{
				re=value;
			}
			return re;
		}
		
		private var isPause:Boolean=false;//暂停开关用于复位按钮时频繁查询的优化
		
		private function resetHandler(e:Event):void
		{
			isPause=true;
			view.reset();
			isPause=false;
			fullSearchHandler(null);
		}
		private function createFavorites():String{
			var obj:Object=view.favoritesPicker.selectedItem;
			var selectValue:int=obj["value"];
			if(selectValue){
				var proxy:FavoritesSearchProxy=appFacade.retrieveProxy_Lite(FavoritesSearchProxy)as FavoritesSearchProxy;
				var list:Array=proxy.getAll();
				var idList:String=(list).toString();
			}
			if(selectValue==1){
				return " and datas.id in(" + idList + ") ";
			}else if(selectValue==2){
				return " and datas.id not in(" + idList + ") ";
			}else{
				return "";
			}
		}
		private function fullSearchHandler(e:Event):void
		{
			var selectObj:String=view.lflistPicker.selectedItem as String;
			var proxy:LimitProxy=ApplicationFacade._.retrieveProxy_Lite(LimitProxy) as LimitProxy;
			proxy.selectLflist=selectObj;
			pureSearch();
		}	
		private function createSerchByLflist():String
		{
			var serch:String=""
			var obj:Object=view.limitPicker.selectedItem;
			var selectValue:String=obj["label"];
			var idList:String="";
			var proxy:LimitProxy=appFacade.retrieveProxy_Lite(LimitProxy)as LimitProxy;
			var lfpackage:LflistPackage=proxy.currentLflist;
			var connect:Array=[];
			switch(selectValue){
				case localize("info_forbidden"):
					idList=lfpackage.forbidden.toString();
					break;
				case localize("info_limit_1"):
					idList=lfpackage.limit.toString();
					break;
				case localize("info_limit_2"):
					idList=lfpackage.semiLimit.toString();
					break;
				case localize("info_in_lflist"):
					connect=connect.concat(lfpackage.forbidden,lfpackage.limit,lfpackage.semiLimit);
					idList=connect.toString();
					break;
				case localize("info_in_limit_list"):
					connect=connect.concat(lfpackage.limit,lfpackage.semiLimit);
					idList=connect.toString();
					break;
				case localize("system_unlimit"):
					return "";
			}
			return " and datas.id in(" + idList + ") ";
		}
		
		private function createView():void
		{
			var configProxy:ConfigProxy=appFacade.retrieveProxy_Lite(ConfigProxy) as ConfigProxy;
			var config:XML=configProxy.sqlConfig;
			
			for(var i:int=0;i<view.pickerList.length;i++){
				var picker:LabelPicker=view.pickerList[i];
				var list:Array=[];
				for each(var item:XML in config.item[i].child){
					var label:String=localize(item.@label);
					list.push({label:label,value:item.@value});
				}
				picker.dataProvider=new ListCollection(list);
				picker.labelField="label";
			}
			view.limitPicker.dataProvider=new ListCollection([
				{label:localize("system_unlimit")},
				{label:localize("info_forbidden")},
				{label:localize("info_limit_1")},
				{label:localize("info_limit_2")},
				{label:localize("info_in_lflist")},
				{label:localize("info_in_limit_list")}
			]);
			view.limitPicker.labelField="label";
			
			view.favoritesPicker.dataProvider=new ListCollection([
				{label:localize("system_unlimit"),value:0},
				{label:localize("info_favorite_in"),value:1}
			]);
			view.favoritesPicker.labelField="label";
			
			
			updateLflist(null);
		}
		private function createLflistPicker():void{
			var re:ListCollection=new ListCollection();
			var proxy:LimitProxy=appFacade.retrieveProxy_Lite(LimitProxy)as LimitProxy;
			var arr:Array=[];
			
			for (var key:String in proxy.lflistDict){
				arr.push(key);
			}
			arr=arr.sort();
			arr.unshift(localize("system_unlimit"));
			re.data=arr;
			view.lflistPicker.dataProvider=re;
			if(proxy.selectLflist){
				view.lflistPicker.selectedItem=proxy.selectLflist;
			}
		}

	}
}