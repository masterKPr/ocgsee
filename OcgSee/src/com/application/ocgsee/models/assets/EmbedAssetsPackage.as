package com.application.ocgsee.models.assets
{
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class EmbedAssetsPackage implements ICardTexture
	{

		private var _cls:Class;
		private static const XML_ATTRIBUTE_NAME:String="COMPLEX_XML";

		private var _complexXML:XML;
		public function EmbedAssetsPackage(cls:Class)
		{
			_cls=cls;
			_complexXML=_cls[XML_ATTRIBUTE_NAME];
			init();		
		}
		private var list:Array=[];

		private var len:int;
		private function init():void
		{
			var xls:XMLList=_complexXML.item;
			for each(var item:XML in xls){
				var texture_class_name:String=item.@texture;
				var config_class_name:String=item.@config;
				var texture_class:Class=_cls[texture_class_name];
				var config_class:Class=_cls[config_class_name];
				var texture:Texture=Texture.fromEmbeddedAsset(texture_class);
				var config:XML=XML(new config_class());
				var textureAtlas:TextureAtlas=new TextureAtlas(texture,config);
				var index:int=int(texture_class_name.split("_")[1]);
				list[index]=textureAtlas;
			}
			var testOne:XML=config.SubTexture[0]
			
			width=testOne.@width;
			
			height=testOne.@height;
			
			len=list.length;
		}
		public var width:int;
		public var height:int;
		public function getCardTexture(id:int):Texture{
			
			var index:int=id%len;
			
			return list[index].getTexture(""+id);
		}
		
	}
}