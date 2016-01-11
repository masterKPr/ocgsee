package com.application.engine.utils
{
	import flash.utils.Dictionary;
	
	/**
	 * 具有动态内存管理功能的哈希表。<br/>
	 * 此类通常用于动态共享高内存占用的数据对象，比如BitmapData。
	 * 它类似Dictionary，使用key-value形式来存储数据。
	 * 但当外部对value的所有引用都断开时，value会被GC标记为可回收对象，并从哈希表移除。<br/>
	 * <b>注意：</b>
	 * 只有引用型的value才能启用动态内存管理，若value是基本数据类型(例如String,int等)时，需手动remove()它。
	 */
	public class SharedMap
	{
		/**
		 * 构造函数
		 * @param groupSize 分组大小,数字越小查询效率越高，但内存占用越高。
		 */		
		public function SharedMap(groupSize:int=200)
		{
			if(groupSize<1)
				groupSize = 1;
			this._groupSize = groupSize;
		}
		
		/**
		 * key缓存字典
		 */		
		private var _keyDict:Dictionary = new Dictionary();
		/**
		 * 上一次的value缓存字典
		 */		
		private var _lastValueDict:Dictionary;
		/**
		 * 通过值获取键
		 * @param value
		 */		
		private function getValueByKey(key:String):*
		{
			var valueDict:Dictionary = _keyDict[key];
			if(!valueDict){
				return null;
				
			}
			var found:Boolean = false;
			var value:*;
			for(value in valueDict)
			{
				if(valueDict[value]===key)
				{
					found = true;
					break;
				}
			}
			if(found==false)
			{
				value = null;
				delete _keyDict[key];
			}
			return value;
		}
		
		/**
		 * 分组大小
		 */		
		private var _groupSize:int = 200;
		/**
		 * 添加过的key的总数
		 */		
		private var _totalKeys:int = 0;
		/**
		 * 设置键值映射
		 * @param key 键
		 * @param value 值
		 */		
		public function save(key:String,value:*):void
		{
			var valueDict:Dictionary = _keyDict[key];
			if(valueDict)
			{
				var oldValue:* = getValueByKey(key);
				if(oldValue!=null)
					delete valueDict[oldValue];
			}
			else
			{
				if(_totalKeys%_groupSize==0){
					_lastValueDict = new Dictionary(true);
				}
				valueDict = _lastValueDict;
				_totalKeys++;
			}
			_keyDict[key] = valueDict;
			valueDict[value] = key;
		}
		/**
		 * 获取指定键的值
		 * @param key
		 */		
		public function take(key:String):*
		{
			return getValueByKey(key);
		}
		/**
		 * 检测是否含有指定键
		 * @param key 
		 */		
		public function has(key:String):Boolean
		{
			var valueDict:Dictionary = _keyDict[key];
			if(!valueDict)
				return false;
			var hasBool:Boolean = false;
			for(var value:* in valueDict)
			{
				if(valueDict[value]===key)
				{
					hasBool = true;
					break;
				}
			}
			if(hasBool==false){
				delete _keyDict[key];
			}
			
			return hasBool;
		}
		/**
		 * 移除指定的键
		 * @param key 要移除的键
		 * @return 是否移除成功
		 */		
		public function remove(key:String):Boolean
		{
			var value:* = getValueByKey(key);
			if(value==null){
				return false;				
			}
			var valueDict:Dictionary = _keyDict[key];
			delete _keyDict[key];
			delete valueDict[value];
			return true;
		}
		/**
		 * 获取键名列表
		 */		
		public function get keys():Vector.<String>
		{
			var keyList:Vector.<String> = new Vector.<String>();
			var cacheDict:Dictionary = new Dictionary();
			for(var key:String in _keyDict)
			{
				var valueDict:Dictionary = _keyDict[key];
				if(cacheDict[valueDict]){
					continue;
				}
				cacheDict[valueDict] = true;
				for each(var validKey:String in valueDict)
				{
					keyList.push(validKey);
				}
			}
			return keyList;
		}
		/**
		 * 获取值列表
		 */		
		public function get values():Array
		{
			var valueList:Array = [];
			var cacheDict:Dictionary = new Dictionary();
			for(var key:String in _keyDict)
			{
				var valueDict:Dictionary = _keyDict[key];
				if(cacheDict[valueDict]){
					continue;
				}				
				cacheDict[valueDict] = true;
				for(var value:* in valueDict)
				{
					valueList.push(value);
				}
			}
			return valueList;
		}
		/**
		 * 刷新缓存并删除所有失效的键值。
		 */		
		public function refresh():void
		{
			var keyList:Vector.<String> = keys;
			for(var key:String in _keyDict)
			{
				if(keyList.indexOf(key)==-1)
					delete _keyDict[key];
			}
		}
	}
}