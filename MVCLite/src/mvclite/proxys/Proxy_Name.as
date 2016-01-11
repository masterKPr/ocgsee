package mvclite.proxys
{
	import flash.utils.getQualifiedClassName;
	
	public class Proxy_Name extends AbstractProxy
	{
		private var _name:String;
		public function Proxy_Name(name:String, data:Object=null)
		{
			this._name=name;
			super(this.NAME, data);
		}
		public override function get NAME():String{
			return this._name+"-"+getQualifiedClassName(this);
		}
	}
}