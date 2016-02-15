package com.application.ocgsee.themes
{
	import feathers.themes.MetalWorksMobileTheme;
	
	public class OcgseeTheme extends MetalWorksMobileTheme
	{
		public function OcgseeTheme(scaleToDPI:Boolean=true)
		{
			super(scaleToDPI);
		}
		protected override function initializeStyleProviders():void{
			super.initializeStyleProviders();
//			this.getStyleProviderForClass(ShowCard).defaultStyleFunction=setShowCardStyles;
		}
		
//		private function setShowCardStyles(view:ShowCard):void
//		{
//			var viewLayout:HorizontalLayout = new HorizontalLayout();
//			viewLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
//			viewLayout.verticalAlign=HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
//			viewLayout.gap=10;
//			viewLayout.paddingLeft=0;
//			viewLayout.paddingRight=0;
//			viewLayout.paddingTop=0;
//			viewLayout.paddingBottom=0;
//			view.layout=viewLayout;
//			
//			var labelLayout:HorizontalLayout = new HorizontalLayout();
//			labelLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
//			labelLayout.verticalAlign=HorizontalLayout.VERTICAL_ALIGN_TOP;
//			labelLayout.paddingLeft=1;
//			labelLayout.paddingRight=1;
//			labelLayout.paddingTop=1;
//			labelLayout.paddingBottom=1;
//			view.labelContent.layout=labelLayout;
//			
//			var btnLayout:VerticalLayout=new VerticalLayout();
//			view.btnContent.layout=btnLayout;
//		}
	}
}