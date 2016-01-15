package com.application.ocgsee.consts
{
	public class GlobalEvents
	{
		public static const LOAD_SOMETING:String="LOAD_SOMETING";
		
		/**
		 *贴图加载完毕 starling才算真正初始化完成 
		 */		
		public static const RES_COMPLETE:String="RES_COMPLETE";
		
		
		
		public static const SEARCH_MULIT:String="SEARCH_MULIT";
		
		public static const SEARCH_SINGLE:String="SEARCH_SINGLE";
		
		
		public static const SEARCH_MULIT_COMPLETE:String="SEARCH_MULIT_COMPLETE";
		
		public static const SEARCH_SINGLE_COMPLETE:String="SEARCH_SINGLE_COMPLETE";
		
		
		public static const LOADING_PROGRESS:String="LOADING_PROGRESS";
		
		public static const INIT_FAVORITES:String="INIT_FAVORITES";
		
		public static const DRAWERS_BEGIN_INTERACTION:String="DRAWERS_BEGIN_INTERACTION";
		
		public static const DRAWERS_STOP_INTERACTION:String="DRAWERS_STOP_INTERACTION";
		
		public static const DRAWERS_OPEN:String="DRAWERS_OPEN";
		
		public static const DRAWERS_CLOSE:String="DRAWERS_CLOSE";
		
		public static const RESULT_LAYOUT_CHANGE:String="RESULT_LAYOUT_CHANGE";
		
		public static const INIT_DB:String="INIT_DB";
		
		public static const CHECK_DB:String="CHECK_DB";
		
		public static const REFRESH_CARD_TEXTURE:String="REFRESH_CARD_TEXTURE";
		
		/**
		 *CardItemRenderer dispose事件
		 */		
		public static const DISPOSE:String="DISPOSE";
		
		/**
		 *内存超过张数限制的时候的回收事件
		 */		
		public static const GC_DISPOSE:String="GC_DISPOSE";
		public function GlobalEvents()
		{
		}
	}
}