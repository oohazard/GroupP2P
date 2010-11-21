package oohazard.friends
{
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	import oohazard.utils.Utils;
	
	public class FriendService
	{		
		
		private static const gateway : String = "http://localhost/amfphp/gateway.php";
		private static var connection : NetConnection;
		
		private static function init() : void
		{
			if (connection == null)
			{		
				connection = new NetConnection;
				connection.connect(gateway);
			}
		}
		
		public static function sayHello(text : String, callback : Function = null):void {
			init();
			var responder : Responder = new Responder(onResult, onFault);
			connection.call("HelloWorld.say", responder, text);
			
			function onResult(result:Object):void {
				trace(String(result));
				if (callback != null)
				{
					callback(String(result));
				}
			}
			
			function onFault(fault:Object):void {
				trace(String(fault.description));
			}		
		}
		
		
		public static function getFriends(networkId : String, callback : Function = null):void {
			init();
			var responder : Responder = new Responder(onResult, onFault);
			connection.call("FriendService.getFriends", responder, networkId);
			
			function onResult(result:Object):void {
				trace(result);
				
				var values : Array = Utils.arrayCollectionToArray(result);
				if (callback != null)
				{
					callback(values);
				}
			}
			
			function onFault(fault:Object):void {
				trace(String(fault.description));
			}		
		}			
	}
}