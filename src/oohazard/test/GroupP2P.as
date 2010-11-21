package oohazard.test
{
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.text.TextField;
	import flash.utils.setInterval;
	
	import oohazard.p2p.friendGroups.FriendsMesh;
	import oohazard.p2p.rendezvous.RendezVousService;
	import oohazard.ui.UI;
	
	public class GroupP2P extends Sprite
	{
		private var rendezVousService : RendezVousService;
		private var friendMesh : FriendsMesh;
		
		private var ui : UI;
		
		
		public function GroupP2P()
		{	
			ui = new UI(this);
			ui.setSkeleton();
			ui.addButton("connectButton", "connect", connect, 200, 350);
		}
		
		private function connect() : void
		{
			rendezVousService = new RendezVousService();
			rendezVousService.addEventListener(NetStatusEvent.NET_STATUS, rendezVousListener);
			rendezVousService.connect();
		}
		
		private function rendezVousListener(event : NetStatusEvent) : void
		{
			trace(event.info.code);
			
			switch (event.info.code) {
				case "NetConnection.Connect.Success":
					friendMesh = new FriendsMesh("testing", rendezVousService);
					friendMesh.addEventListener(NetStatusEvent.NET_STATUS, friendMeshListener);
					var groupString : String = friendMesh.initialize(ui.getText("idText"));
							
					ui.appendText("LogList", "rendez vous established, creating Friend Mesh with group : " + groupString);
					
					setInterval(function():void{friendMesh.sendData("hello from " + ui.getText("idText"));},3000);
					break;
				case "NetGroup.Connect.Success":
					ui.appendText("LogList", "group connected ..." + event.info.toString());
					if (friendMesh != null)
					{
						ui.setText("groupStat", "estimatedMemberCount " + friendMesh.myGroup.estimatedMemberCount);
						ui.appendText("groupStat", "neightbour rCount " + friendMesh.myGroup.neighborCount);
						ui.appendText("groupStat", "group info : \n" + friendMesh.myGroup.info.toString());
					}
					break;
			}
		}
		
		private function friendMeshListener(event : NetStatusEvent) : void
		{
		
			if (friendMesh != null)
			{
				ui.setText("groupStat", "estimatedMemberCount " + friendMesh.myGroup.estimatedMemberCount);
				ui.appendText("groupStat", "neightbour rCount " + friendMesh.myGroup.neighborCount);
				ui.appendText("groupStat", "group info : \n" + friendMesh.myGroup.info.toString());
			}
			
			trace(event.info.code);
			ui.appendText("LogList", "netGroup event : " + event.info.code);
			switch(event.info.code){
				case "NetGroup.Posting.Notify":
					trace(event.info.message.data);
					ui.setText("messageText", event.info.message.data);
					break;
			}
		}

	}
}