package com.application.ocgsee.utils
{
	import com.application.ApplicationFacade;
	public function localize(key:String, ...args):String{
		args.unshift(key);
		return ApplicationFacade._.locale.localize.apply(null,args);
	}
}