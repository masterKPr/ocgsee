package
{
	import com.application.ApplicationFacade;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.Capabilities;
	
	import feathers.FEATHERS_VERSION;
	
	import starling.core.Starling;
	
	public class OcgSee extends Sprite
	{
		public function OcgSee()
		{
			super(); 
			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			trace("air:",Capabilities.version);
			trace("starling:",Starling.VERSION);
			trace("feathers:",FEATHERS_VERSION);
			
			ApplicationFacade._.startup(this);
		}
	}
}