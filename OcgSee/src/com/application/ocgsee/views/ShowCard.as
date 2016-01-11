package com.application.ocgsee.views
{
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.Panel;
	import feathers.controls.ScrollContainer;
	import feathers.skins.IStyleProvider;
	
	import starling.display.Sprite;
	
	public class ShowCard extends ScrollContainer
	{


		public var netImage:SaveImageLoader;

		
		public var attributeLabel:Label;

		public var imgContent:Sprite;


		public var labelContent:ScrollContainer;

		public var copyBtn:Button;

		public var saveBtn:Button;

		public var backBtn:Button;

		public var btnContent:ScrollContainer;
		public var id:int;

		public static var globalStyleProvider:IStyleProvider;
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return globalStyleProvider;
		}
		public function ShowCard(scale:Number=1.5)
		{
			super();
			var leftContent:Sprite=new Sprite();
			this.addChild(leftContent);
			
			imgContent=new Sprite();
			leftContent.addChild(imgContent);
			btnContent=new ScrollContainer();

			netImage=new SaveImageLoader();
			netImage.width=177*scale;
			netImage.height=254*scale;
			imgContent.addChild(netImage);
			labelContent=new ScrollContainer();
			
			labelContent.height=254*scale;
			labelContent.width=180*scale;
			
			var rightContent:ScrollContainer=new ScrollContainer();
			this.addChild(rightContent);
			
			
			labelContent.verticalScrollPolicy = Panel.SCROLL_POLICY_ON;
			labelContent.horizontalScrollPolicy=Panel.SCROLL_POLICY_OFF;
			
			rightContent.addChild(labelContent);
			rightContent.addChild(btnContent);
			attributeLabel=new Label();
			
			attributeLabel.width=177*scale;
			attributeLabel.wordWrap=true;

			labelContent.addChild(attributeLabel);
			
			copyBtn=new Button();
			copyBtn.label="复制";
			copyBtn.width=177*scale;
			copyBtn.height=254*scale/2;
			copyBtn.alpha=1;
			btnContent.addChild(copyBtn);
			
			saveBtn=new Button();
			saveBtn.label="收藏 ☆";
			saveBtn.width=177*scale;
			saveBtn.height=254*scale/2;
			saveBtn.alpha=1;
			btnContent.addChild(saveBtn);
			
			backBtn=new Button();
			backBtn.label="返回";
			backBtn.width=177*scale;
			backBtn.height=254*scale/3;
			backBtn.alpha=1;
//			btnContent.addChild(backBtn);
			
			btnContent.visible=false;
		}
		
	}
}