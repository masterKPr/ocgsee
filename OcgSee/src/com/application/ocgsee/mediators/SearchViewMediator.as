package com.application.ocgsee.mediators
{
	import com.application.ApplicationFacade;
	import com.application.ocgsee.consts.GlobalEvents;
	import com.application.ocgsee.consts.SearchType;
	import com.application.ocgsee.models.LflistPackage;
	import com.application.ocgsee.proxys.AssetsProxy;
	import com.application.ocgsee.proxys.FavoritesSearchProxy;
	import com.application.ocgsee.proxys.LimitProxy;
	import com.application.ocgsee.proxys.SQLProxy;
	import com.application.ocgsee.views.SearchView;
	
	import flash.utils.setTimeout;
	
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.PickerList;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	
	import mvclite.mediator.Mediator_Lite;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class SearchViewMediator extends Mediator_Lite
	{
		public var view:SearchView;
		public function SearchViewMediator(viewComponent:Object=null)
		{
			super(viewComponent);
		}
		public override function onRegister():void{
			createView();
			
			eventsProxy.regist(view,Event.ADDED_TO_STAGE,viewAddedHandler)
			eventsProxy.regist(view.resetBtn,Event.TRIGGERED,resetHandler);
			
			eventsProxy.regist(view.mainType_Picker,Event.CHANGE,onSearchChange);
			eventsProxy.regist(view.attribute_Picker,Event.CHANGE,onSearchChange);
			eventsProxy.regist(view.ot_Picker,Event.CHANGE,onSearchChange);
			eventsProxy.regist(view.level_Picker,Event.CHANGE,onSearchChange);
			eventsProxy.regist(view.race_Picker,Event.CHANGE,onSearchChange);
			eventsProxy.regist(view.child_type_Picker,Event.CHANGE,onSearchChange);
			eventsProxy.regist(view.searchInput,Event.CHANGE,onSearchChange);
			eventsProxy.regist(view.tokenToggle,Event.CHANGE,onSearchChange);
			eventsProxy.regist(view.limit_Picker,Event.CHANGE,onSearchChange);
			eventsProxy.regist(view.favorites_Picker,Event.CHANGE,onSearchChange);
			
			eventsProxy.regist(view.layoutStepper,Event.CHANGE,onStepChange);
			onSearchChange(null);
		}
		
		
		private function onStepChange(e:Event):void
		{
			appFacade.sendNotification(GlobalEvents.RESULT_LAYOUT_CHANGE,view.layoutStepper.value);
		}
		
		private function viewAddedHandler(e:Event):void
		{
			eventsProxy.remove(view,Event.ADDED_TO_STAGE,viewAddedHandler)
			
			setTimeout(resizePicker,1);
			setTimeout(resizeHeader,2);
		}
		private function resizePicker():void{
			var pickList:Array=[
				 view.limit_Picker,
				 view.mainType_Picker,
				 view.attribute_Picker,
				 view.ot_Picker,
				 view.level_Picker,
				 view.race_Picker,
				 view.child_type_Picker,
				 view.favorites_Picker
				 ];
			var maxWidth:int=0;
			for each(var picker:PickerList in pickList){
				if(picker.width>maxWidth){
					maxWidth=picker.width;
				}
			}
			maxWidth+=30;
			for each(picker in pickList){
				picker.width=maxWidth;
			}
		}
		private function resizeHeader():void{
			var maxWidth:int=0;
			var maxHeiht:int=0;
			for (var i:int=0;i<view.numChildren;i++){
				var header:Header=view.getChildAt(i) as Header;
				if(header){
					if(header.width>maxWidth){
						maxWidth=header.width;
					}
					if(header.height>maxHeiht){
						maxHeiht=header.height;
					}
				}
			}
			maxWidth+=50;
			for (i=0;i<view.numChildren;i++){
				var camp:DisplayObject=view.getChildAt(i);
				if(camp){
					camp.width=maxWidth;
					camp.height=maxHeiht;
				}
			}
			
		}
		private function onSearchChange(e:Event):void
		{
			if(isPause)return;
			if(isReset()){
				view.resetBtn.label="复位";
			}else{
				view.resetBtn.label="●复位";
			}
			sendNotification(GlobalEvents.SEARCH,createSearchText(),SearchType.MULTI);
		}
		
		private function createSearchText():String{
			var result:String=createSerchByLflist();
			for(var i:int=0;i<view.pickerList.length;i++){
				var picker:PickerList=view.pickerList[i];
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
			var value:Boolean=view.tokenToggle.isSelected;
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
			view.mainType_Picker.selectedIndex=0;
			view.attribute_Picker.selectedIndex=0;
			view.ot_Picker.selectedIndex=0;
			view.level_Picker.selectedIndex=0;
			view.race_Picker.selectedIndex=0;
			view.child_type_Picker.selectedIndex=0;
			view.limit_Picker.selectedIndex=0;
			view.favorites_Picker.selectedIndex=0;
			view.searchInput.text="";
			isPause=false;
			onSearchChange(null);
		}
		private function isReset():Boolean{
			return view.mainType_Picker.selectedIndex==0&&
			view.attribute_Picker.selectedIndex==0&&
			view.ot_Picker.selectedIndex==0&&
			view.level_Picker.selectedIndex==0&&
			view.race_Picker.selectedIndex==0&&
			view.child_type_Picker.selectedIndex==0&&
			view.limit_Picker.selectedIndex==0&&
			view.favorites_Picker.selectedIndex==0&&
			view.searchInput.text=="";
		}
		private function createFavorites():String{
			var obj:Object=view.favorites_Picker.selectedItem;
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
		
		private function createSerchByLflist():String
		{
			var serch:String=""
			var obj:Object=view.limit_Picker.selectedItem;
			var selectValue:int=obj["value"];
			var idList:String="";
			var proxy:LimitProxy=appFacade.retrieveProxy_Lite(LimitProxy)as LimitProxy;
			var lfpackage:LflistPackage=proxy.currentLflist;
			switch(selectValue){
				case 0:
					idList=(lfpackage.forbidden).toString();
					break;
				case 1:
					idList=(lfpackage.limit).toString();
					break;
				case 2:
					idList=(lfpackage.semiLimit).toString();
					break;
				case 4:
					idList=(lfpackage.forbidden).toString() + "," + (lfpackage.limit).toString() + "," + (lfpackage.semiLimit).toString();
					break;
				case 3:
					return "";
					break;
			}
			return " and datas.id in(" + idList + ") ";
		}
		
		private function createView():void
		{
			var assetsProxy:AssetsProxy=appFacade.retrieveProxy_Lite(AssetsProxy) as AssetsProxy;
			var config:XML=assetsProxy.takeXML("SQL_Config");
			
			for(var i:int=0;i<view.pickerList.length;i++){
				var picker:PickerList=view.pickerList[i];
				var header:Header=view.headerList[i];
				header.title=config.item[i].@prompt;
				var list:Array=[];
				for each(var item:XML in config.item[i].child){
					var label:String=ApplicationFacade._.locale.localize(item.@label);
					list.push({label:label,value:item.@value});
				}
				picker.dataProvider=new ListCollection(list);
				picker.labelField="label";
				picker.listFactory=listFactory;
				
				//				picker.selectedIndex=-1;
			}
			view.limitHeader.title="禁限选择";
			view.limit_Picker.dataProvider=new ListCollection([
				{label:"无限制    ",value:3},
				{label:"禁止卡",value:0},
				{label:"限制卡",value:1},
				{label:"准限制",value:2}
				//				{label:"禁限卡表",value:4}
			]);
			view.limit_Picker.labelField="label";
			
			view.favoritesHeader.title="收藏列表";
			view.favorites_Picker.dataProvider=new ListCollection([
				{label:"无限制    ",value:0},
				{label:"在列表中",value:1}
			]);
			view.favorites_Picker.labelField="label";
			
			picker.listFactory=listFactory;
			
			view.toggleHeader.title="衍生物";
			
			view.layoutHeader.title="布局列数";
		}
		private function listFactory():List
		{
			var list:List = new List();
			list.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.labelField = "label";
				return renderer;
			};
			return list;
		};
	}
}