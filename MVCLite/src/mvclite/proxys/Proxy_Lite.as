package mvclite.proxys
{
	import flash.utils.getQualifiedClassName;
	
	
	public class Proxy_Lite extends AbstractProxy
	{
		public function Proxy_Lite(data:Object=null)
		{
			super(this.NAME, data);
		}
		public override function get NAME():String
		{
			return getQualifiedClassName(this);
		}

	}
}