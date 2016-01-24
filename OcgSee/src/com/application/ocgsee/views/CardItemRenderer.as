package com.application.ocgsee.views
{
	import com.application.ApplicationFacade;
	import com.application.engine.interfaces.ICardTexture;
	import com.application.ocgsee.consts.CallEvents;
	import com.application.ocgsee.consts.GlobalEvents;
	import com.application.ocgsee.proxys.ILimit;
	import com.application.ocgsee.utils.localize;
	
	import flash.geom.Point;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class CardItemRenderer extends FeathersControl implements IListItemRenderer
	{
		public var cardsTextures:ICardTexture;
		public var facade:IFacade;
		public static var selectTexture:Texture;
		public static var newCardTexture:Texture;
		public var limitProxy:ILimit;
		
		public override function dispose():void{
			this.dispatchEvent(new Event(GlobalEvents.DISPOSE));
			super.dispose();
		}
		public function CardItemRenderer(cardWidth:Number,cardHeight:Number)
		{
			_cardWidth=cardWidth;
			_cardHeight=cardHeight;
			cardImage=new SaveImageLoader();
			cardImage.width=_cardWidth;
			cardImage.height=_cardHeight;

			
			this.addChild(cardImage);
			
			_limitMark=new ImageLoader();
			this.addChild(_limitMark);
			_limitMark.width=32;
			_limitMark.height=32;
			_limitMark.x=3;
			_limitMark.y=3;
			
			_selectImg=new ImageLoader();
			_selectImg.width=_cardWidth;
			_selectImg.height=_cardHeight;
			this.addChild(_selectImg);
			
			_newMarkImg=new ImageLoader();
			_newMarkImg.x=5;
			_newMarkImg.y=5;
			this.addChild(_newMarkImg);
			
			
			
			_label=new TextField(_cardWidth/2,_cardHeight/5,"","Verdana",35);
			
			_label.hAlign=HAlign.RIGHT;
			_label.vAlign=VAlign.BOTTOM;
			_label.autoScale=true;
//			_label.bold=true;
			_label.y=_cardHeight-_label.height-5;
			_label.x=_cardWidth-_label.width-5;
			
			
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
						if (!ApplicationFacade._.globalProxy.isDrawOpen){
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
		public var labelField:String;
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
		
		protected var _isSelected:Boolean;
		
		public var cardImage:SaveImageLoader;

		private var _limitMark:ImageLoader;

		private var _selectImg:ImageLoader;

		private var _cardWidth:Number;

		private var _cardHeight:Number;

		private var _label:TextField;

		private var _newMarkImg:ImageLoader;
		
		
		public function get isSelected():Boolean
		{
			return this._isSelected;
		}
		
		public function set isSelected(value:Boolean):void
		{
			if(this._isSelected == value)
			{
				return;
			}

			this._isSelected = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			if(this._isSelected){
				var target:DisplayObject=this;
				var f:Function=function():void{
					facade.sendNotification(CallEvents.CALL_ONE_CARD,{target:target,id:_data.id});
				}
				Starling.current.juggler.delayCall(f,0.0001);
				
			}else{
				facade.sendNotification(CallEvents.HIDE_ONE_CARD);
			}
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
			if(selectionInvalid){
				if(isSelected){
//					this.alpha=0.3
					_selectImg.source=selectTexture
				}else{
//					this.alpha=1;
					_selectImg.source=null;
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
		private var _isNewCard:Boolean;

		public function get isNewCard():Boolean
		{
			return _isNewCard;
		}

		public function set isNewCard(value:Boolean):void
		{
			_isNewCard = value;
			if(_isNewCard){
				_newMarkImg.source=newCardTexture;
			}else{
				_newMarkImg.source=null;
			}
		}
		public function set limitSource(source:Texture):void{
			_limitMark.source=source;
		}
		protected function commitData():void
		{
			if(this._data)
			{
				//				this.itemLabel.text = this._data[labelField];
				cardImage.source=cardsTextures.cardTexture(this._data.id);
				limitSource=limitProxy.getLimitMarkImg(this._data.id);
				
				if(this._data.ot==1){
					_label.color=0x0000ff;
					_label.text=localize("card_ot_1_simple");
					this.addChild(_label);
				}else if(this._data.ot==2){
					_label.color=0xff0000;
					_label.text=localize("card_ot_2_simple");
					this.addChild(_label);
				}else{
					_label.text="";
					this.removeChild(_label);
				}
				isNewCard=ApplicationFacade._.globalProxy.isNewCard(this._data.id);
			}
			else
			{
				//				this.itemLabel.text = "";
				cardImage.source=null;
				limitSource=null;
				isNewCard=false;
			}
		}
		
		protected function layout():void
		{
			//			this.itemLabel.width = this.actualWidth;
			//			this.itemLabel.height = this.actualHeight;
		}
	}
}