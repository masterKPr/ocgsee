package com.application.engine.utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import framework.log.LogUtils;
	
	public class FileUtils
	{
		public function FileUtils()
		{
		}
		public static function readFile(file:File):String{
			var re:String;
			if(file.exists){
				var stream:FileStream=new FileStream();
				stream.open(file,FileMode.READ);
				re=stream.readUTFBytes(stream.bytesAvailable);
				setTimeout(stream.close, 1)
			}else{
				LogUtils.error("加载本地文件url:"+file.nativePath+"不存在");
			}
			return re;
		}
		public static function writeFileBytes(file:File,bytes:ByteArray):void{
			var stream:FileStream=new FileStream();
			stream.open(file,FileMode.WRITE);
			stream.writeBytes(bytes);
			setTimeout(stream.close, 1)
		}
		public static function readFileBytes(file:File):ByteArray{
			var re:ByteArray=new ByteArray;
			if(file.exists){
				var stream:FileStream=new FileStream();
				stream.open(file,FileMode.READ);
				stream.readBytes(re);//readUTFBytes(stream.bytesAvailable);
				setTimeout(stream.close, 1)
			}else{
				LogUtils.error("加载本地文件url:"+file.nativePath+"不存在");
			}
			return re;
		}
	}
}