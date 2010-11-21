package oohazard.test
{
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.text.TextField;
	import flash.utils.setInterval;
	
	import oohazard.p2p.rendezvous.RendezVousService;
	import oohazard.ui.UI;
	
	public class GroupListener extends Sprite
	{
		private var rendezVousService : RendezVousService;
		private var friendMesh : ListenerFriendMesh;
		
		private var ui : UI;
		
		public function GroupListener()
		{
			rendezVousService = new RendezVousService();
			rendezVousService.addEventListener(NetStatusEvent.NET_STATUS, rendezVousListener);
			rendezVousService.connect();
			
			ui = new UI(this);
			ui.setSkeleton();
		}
		
		private function rendezVousListener(event : NetStatusEvent) : void
		{
			switch (event.info.code) {
				case "NetConnection.Connect.Success":
					friendMesh = new ListenerFriendMesh("testing", rendezVousService);
					friendMesh.addEventListener(NetStatusEvent.NET_STATUS, friendMeshListener);
					
					
					var groupString : String = friendMesh.initialize("friend666");
					
					ui.appendText("LogList", "rendez vous established, creating Friend Mesh with group : " + groupString);

					
					//setInterval(function():void{friendMesh.sendData("hello");},3000);
					break;
				case "NetGroup.Connect.Success":
					ui.appendText("LogList", "group connected ..." + event.info.toString());
					break;
			}
		}
		
		private function friendMeshListener(event : NetStatusEvent) : void
		{
			trace(event.info.code);
			ui.appendText("LogList", "netGroup event : " + event.info.code);
			switch(event.info.code){
				case "NetGroup.Posting.Notify":
					trace(event.info.message);
					ui.setText("messageText", event.info.message.data);
					break;
			}
		}
		
	}
}