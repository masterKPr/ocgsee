package com.application.ocgsee.utils
{
	import com.application.ApplicationFacade;
	import com.application.ocgsee.consts.GlobalNotifications;
	
	import flash.utils.Dictionary;
	
	import framework.log.LogUtils;
	
	import starling.textures.Texture;
	
	public class ImageCache
	{
		public function ImageCache()
		{
		}
		private var _dict:Dictionary=new Dictionary(true);
		private var _gcList:GCList=new GCList(80,remove);
		public function take(key:String):Texture{
			var re:Texture;
			var vo:TextureVO=_dict[key];
			if(vo){
				re= vo.texture;
			}
			_gcList.push(key);
			return re;
		}
		public function takeID(id:int):Texture{
			var cardJPG:String=ApplicationFacade._.globalProxy.get_CardJPG_ID(id);
			return take(cardJPG);
		}
		public function has(key:String):Boolean{
			return Boolean(_dict[key]);
		}
		public function save(key:String,value:Texture):void{
			if(_dict[key]){
				LogUtils.error(key+"含有原有值");
			}
			_gcList.push(key);
			_dict[key]= new TextureVO(key,value);
			
		}
		/**
		 *基于cardJPG存储的 
		 * @param key
		 * 
		 */		
		public function remove(key:String):void{
			var texture:TextureVO=_dict[key];
			var obj:Object={
				id:texture.id
			};
			LogUtils.log("销毁材质:"+key);
			texture.dispose();
			delete _dict[key];

			ApplicationFacade._.sendNotification(GlobalNotifications.GC_DISPOSE,obj);
		}
		public function reset():void{
			for (var key:String in _dict){
				remove(key);
			}
		}
		private static var _instance:ImageCache;
		public static function get _():ImageCache{
			return _instance||=new ImageCache();
		}
	}
}
import starling.textures.Texture;

class TextureVO{
	public var texture:Texture;
	public var key:String;
	public var id:int;
	public function TextureVO(key:String,texture:Texture){
		this.id=key.split(".")[0];
		this.key=key;
		this.texture=texture;
	}
	public function dispose():void{
		this.texture.dispose();
		this.texture=null;
	}
}