package com.application.ocgsee.proxys
{
	import starling.textures.Texture;

	public interface ILimit
	{
		 function getLimitMarkImg(id:int):Texture
		 function getLimitMark(id:int):String
	}
}