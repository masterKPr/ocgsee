package com.application.ocgsee.views
{
	import com.application.ApplicationFacade;
	import com.application.ocgsee.consts.GlobalEvents;
	
	import flash.geom.Point;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	[Event(name="dataChange", type="flash.events.Event")]
	public class CardItemRenderer extends FeathersControl implements IListItemRenderer
	{
		
		public static const DATA_CHANGE:String="dataChange";
		
		public var selectedTexture:Texture;
		
		private var _isSelected:Boolean;
		
		private var _cardImage:SaveImageLoader;
		
		private var _limitMark:ImageLoader;
		
		private var _selectImg:ImageLoader;
		
		private var _cardWidth:Number;
		
		private var _cardHeight:Number;
		
		private var _otLabel:TextField;
		
		private var _newMarkImg:ImageLoader;
		
		public override function dispose():void{
			this.dispatchEvent(new Event(GlobalEvents.DISPOSE));
			super.dispose();
		}
		public function CardItemRenderer(cardWidth:Number,cardHeight:Number)
		{
			_cardWidth=cardWidth;
			_cardHeight=cardHeight;
			
			_cardImage=new SaveImageLoader();
			_cardImage.width=_cardWidth;
			_cardImage.height=_cardHeight;
			this.addChild(_cardImage);
			
			_limitMark=new ImageLoader();
			_limitMark.width=cardWidth/3;
			_limitMark.height=cardWidth/3;
			_limitMark.x=cardWidth/40;
			_limitMark.y=cardWidth/40;
			this.addChild(_limitMark);
			
			_selectImg=new ImageLoader();
			_selectImg.width=_cardWidth;
			_selectImg.height=_cardHeight;
			this.addChild(_selectImg);
			_newMarkImg=new ImageLoader();
			_newMarkImg.x=cardWidth/40;
			_newMarkImg.y=cardWidth/40;
			_newMarkImg.width=cardWidth/3;
//			_newMarkImg.height=cardWidth/3;
			this.addChild(_newMarkImg);
			
			_otLabel=new TextField(_cardWidth/2,_cardHeight/5,"","Verdana",35);
			_otLabel.hAlign=HAlign.RIGHT;
			_otLabel.vAlign=VAlign.BOTTOM;
			_otLabel.autoScale=true;
			//			_label.bold=true;
			_otLabel.y=_cardHeight-_otLabel.height-cardWidth/40;
			_otLabel.x=_cardWidth-_otLabel.width-cardWidth/40;
//						this.addChild(_otLabel);
			
			this.addEventListener(TouchEvent.TOUCH, touchHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		
		
		private static const HELPER_POINT:Point = new Point();
		
		protected var touchPointID:int = -1;
		
		protected function removedFromStageHandler(event:Event):void
		{
			this.touchPointID = -1;
		}
		protected function touchHandler(event:TouchEvent):void
		{
			const touches:Vector.<Touch> = event.getTouches(this);
			if(touches.length == 0)
			{
				//hover has ended
				return;
			}
			if(this.touchPointID >= 0)
			{
				var touch:Touch;
				for each(var currentTouch:Touch in touches)
				{
					if(currentTouch.id == this.touchPointID)
					{
						touch = currentTouch;
						break;
					}
				}
				if(!touch)
				{
					return;
				}
				if(touch.phase == TouchPhase.ENDED)
				{
					this.touchPointID = -1;
					
					touch.getLocation(this, HELPER_POINT);
					//check if the touch is still over the target
					//also, only change it if we're not selected. we're not a toggle.
					if(this.hitTest(HELPER_POINT, true) != null )//&& !this._isSelected
					{
						if (!ApplicationFacade._.globalProxy.isDrawOpen)
						{
							this.isSelected = !this.isSelected;
						}
						
					}
					return;
				}
			}
			else
			{
				for each(touch in touches)
				{
					if(touch.phase == TouchPhase.BEGAN)
					{
						this.touchPointID = touch.id;
						return;
					}
				}
			}
		}
		
		//		protected var itemLabel:Label;
		
		protected var _index:int = -1;
		
		public function get index():int
		{
			return this._index;
		}
		
		public function set index(value:int):void
		{
			if(this._index == value)
			{
				return;
			}
			this._index = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		protected var _owner:List;
		
		public function get owner():List
		{
			return List(this._owner);
		}
		
		public function set owner(value:List):void
		{
			if(this._owner == value)
			{
				return;
			}
			this._owner = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		protected var _data:Object;
		public function get data():Object
		{
			return this._data;
		}
		
		public function set data(value:Object):void
		{
			if(this._data == value)
			{
				return;
			}
			this._data = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function set loadingAndError(value:Texture):void
		{
			_cardImage.loadingTexture=value;
			_cardImage.errorTexture=value;
		}
		
		public function get cardSource():Object
		{
			return _cardImage.source;
		}
		
		public function set cardSource(value:Object):void
		{
			_cardImage.source=value;
		}
		
		public function get isSelected():Boolean
		{
			return this._isSelected;
		}
		
		public function set isSelected(value:Boolean):void
		{
			if(ApplicationFacade._.globalProxy.isDrawOpen||this._isSelected == value)
			{
				return;
			}
			this._isSelected = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}
		
		override protected function initialize():void
		{
			
		}
		
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			
			if(dataInvalid)
			{
				this.commitData();
			}
			if(selectionInvalid)
			{
				if(isSelected)
				{
					selectedSource=selectedTexture;
				}
				else
				{
					selectedSource=null;
				}
				
			}
			
			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;
			
			if(dataInvalid || sizeInvalid)
			{
				this.layout();
			}
		}
		
		protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			//			var newWidth:Number = this.explicitWidth;
			//			if(needsWidth)
			//			{
			//				newWidth = this.itemLabel.width;
			//			}
			//			var newHeight:Number = this.explicitHeight;
			//			if(needsHeight)
			//			{
			//				newHeight = this.itemLabel.height;
			//			}
			return this.setSizeInternal(_cardWidth, _cardHeight, false);
		}
		
		
		public function set newMarkSource(value:Texture):void
		{
			_newMarkImg.source=value;
		}
		public function set limitSource(source:Texture):void
		{
			_limitMark.source=source;
		}
		public function set selectedSource(value:Texture):void
		{
			_selectImg.source=value;
		}
		public function setLabel(text:String,color:int):void
		{
			_otLabel.text=text;
			_otLabel.color=color;
			if(text=="")
			{
				this.removeChild(_otLabel);
			}
			else
			{
				this.addChild(_otLabel);
			}
		}
		protected function commitData():void
		{
			this.dispatchEvent(new Event(DATA_CHANGE));
		}
		
		protected function layout():void
		{
			//			this.itemLabel.width = this.actualWidth;
			//			this.itemLabel.height = this.actualHeight;
		}
		private var _factoryID:String;
		public function get factoryID():String
		{
			// TODO Auto Generated method stub
			return _factoryID;
		}
		
		public function set factoryID(value:String):void
		{
			// TODO Auto Generated method stub
			_factoryID=value;
		}
		
	}
}