package oohazard.p2p.rendezvous
{
	import flash.errors.IllegalOperationError;
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	//import lib.event.ConnectionEvent;
	//import lib.event.IncomingConnectionEvent;
	
	public class RendezVousService extends EventDispatcher
	{
		private const RendezVousAddress : String = "rtmfp://p2p.rtmfp.net";
		private const DeveloperKey : String = "a6b44c10cf73bdb3f90e80c0-1d11f1ce71b5";
			
		private var _connection : NetConnection;
		public function get connection() : NetConnection { return _connection;	}
		
		private var _myPeerId : String;
		public function get myPeerId() : String { return _myPeerId;	}
		
		public function RendezVousService()
		{
			// connect();
		}
		
		public function connect() : void
		{
			_connection = new NetConnection();
			_connection.addEventListener(NetStatusEvent.NET_STATUS, netConnectionHandler);
			_connection.connect(RendezVousAddress + "/" + DeveloperKey);
		}
		
		private function netConnectionHandler(event : NetStatusEvent) : void
		{
			trace(event.info.code);
			switch (event.info.code) {
				case "NetConnection.Connect.Success":
					_myPeerId = connection.nearID;
					dispatchEvent(event);
					break;
				case "NetConnection.Connect.Failed":
					dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "You failed to connect to the Rendez vous service (" + RendezVousAddress + ")."));
					break;
				case "NetStream.Connect.Closed":
					trace("Connection CLosed");
					// TODO: Re-establish the connection
					break;
				case "NetGroup.Connect.Success":
					dispatchEvent(event);
					
					break;
			}		
		}
		
	}
}