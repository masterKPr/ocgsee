package com.application.ocgsee.views
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.NumericStepper;
	import feathers.controls.PickerList;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TextInput;
	import feathers.controls.ToggleSwitch;
	import feathers.skins.IStyleProvider;
	
	import starling.display.DisplayObject;
	
	
	public class SearchView extends ScrollContainer
	{
		public var mainType_Picker:PickerList;
		public var attribute_Picker:PickerList;
		public var ot_Picker:PickerList;
		public var level_Picker:PickerList;
		public var race_Picker:PickerList;
		public var child_type_Picker:PickerList;
		
		

		public var resetBtn:Button;

		public var pickerList:Vector.<PickerList>=new Vector.<PickerList>;
		
		public var headerList:Vector.<Header>=new Vector.<Header>();

		public var searchInput:TextInput;

		public var tokenToggle:ToggleSwitch;

		public var toggleHeader:Header;
		public var limit_Picker:PickerList;

		public var limitHeader:Header;

		public var favoritesHeader:Header;

		public var favorites_Picker:PickerList;
		
		public function SearchView()
		{
			super();
			create();
		}
		public static var globalStyleProvider:IStyleProvider;

		public var layoutStepper:NumericStepper;

		public var layoutHeader:Header;

		override protected function get defaultStyleProvider():IStyleProvider
		{
			return SearchView.globalStyleProvider;
		}
		private function create():void
		{
			
			limitHeader=new Header();
			limit_Picker=new PickerList();
			limitHeader.rightItems=new <DisplayObject>[limit_Picker];
			this.addChild(limitHeader);
			
			
			
			mainType_Picker=new PickerList();
			attribute_Picker=new PickerList();
			ot_Picker=new PickerList();
			level_Picker=new PickerList();
			race_Picker=new PickerList();

			child_type_Picker=new PickerList();
			
			
			pickerList.push(mainType_Picker);
			pickerList.push(attribute_Picker);
			pickerList.push(ot_Picker);
			pickerList.push(level_Picker);
			pickerList.push(race_Picker);
			pickerList.push(child_type_Picker);
			
			for(var i:int=0;i<pickerList.length;i++){
				var item:PickerList=pickerList[i];
				var header:Header=new Header();
				
				header.rightItems=new <DisplayObject>[item];
				headerList.push(header);
				this.addChild(header);
			}
			
			
			favoritesHeader=new Header();
			favorites_Picker=new PickerList();
			favoritesHeader.rightItems=new <DisplayObject>[favorites_Picker];
			this.addChild(favoritesHeader);
			
			toggleHeader=new Header();
			tokenToggle=new ToggleSwitch();
			toggleHeader.rightItems=new <DisplayObject>[tokenToggle];
			this.addChild(toggleHeader);
			
			layoutStepper=new NumericStepper();
			this.layoutStepper.minimum = 3;
			this.layoutStepper.maximum = 7;
			this.layoutStepper.step = 1;
			this.layoutStepper.value=4;
			
			layoutHeader=new Header();
			layoutHeader.rightItems=new <DisplayObject>[layoutStepper];
			this.addChild(layoutHeader);
			
			searchInput = new TextInput();
			searchInput.styleNameList.add(TextInput.ALTERNATE_NAME_SEARCH_TEXT_INPUT);
			searchInput.prompt = "关键字";
			this.addChild(this.searchInput);
			
			resetBtn=new Button();
			resetBtn.label="复位";
			this.addChild(resetBtn);
			

			
		}
	}
}