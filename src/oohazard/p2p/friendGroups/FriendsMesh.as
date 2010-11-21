package oohazard.p2p.friendGroups
{
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetGroup;
	import flash.text.engine.EastAsianJustifier;
	
	import oohazard.friends.FriendService;
	import oohazard.p2p.rendezvous.RendezVousService;
	import oohazard.utils.StringUtils;
	import oohazard.utils.VectorUtils;

	public class FriendsMesh extends EventDispatcher
	{
		private var _applicationName : String;
		
		private var _rendezVousService : RendezVousService;
		
		private var _password : String;
		
		
		private var _myGroup : NetGroup;
		public function get myGroup() : NetGroup{return _myGroup;}
		private var _myGroupSpec : GroupSpecifier;
		
		
		private var _friendGroups : Vector.<NetGroup>;
		
		public function FriendsMesh(applicationName : String, rendezVousService : RendezVousService)
		{
			_applicationName = applicationName;
			_rendezVousService = rendezVousService;
			_password = StringUtils.generateRandomString(12);
			_friendGroups = new Vector.<NetGroup>;
		}
		
		public function initialize(appUserId : String) : String
		{			
			_myGroupSpec = new GroupSpecifier(_applicationName + "/"+ appUserId);
			_myGroupSpec.serverChannelEnabled = true;
			_myGroupSpec.postingEnabled = true;
			
			var groupString : String = _myGroupSpec.groupspecWithAuthorizations(); 
			_myGroup = new NetGroup(_rendezVousService.connection, groupString);
			//_myGroup.addEventListener(NetStatusEvent.NET_STATUS, myGroupStatusHandler);
			
			FriendService.getFriends(appUserId, onFriendsReady);
			
			return groupString;
		}
		
		public function onFriendsReady(result : Array) : void
		{
			
			for each (var friendArray : Array in result)
			{
				// shoudl only connect on currently connected friend, is there a way to check whether a group is empty ?
				var friendId : String = friendArray[0];
				var friendGroupsSpec : GroupSpecifier = new GroupSpecifier(_applicationName + "/" + friendId);
				friendGroupsSpec.serverChannelEnabled = true;
				friendGroupsSpec.postingEnabled = true;

				var group : NetGroup = new NetGroup(_rendezVousService.connection, friendGroupsSpec.groupspecWithoutAuthorizations());
				_friendGroups.push(group);
				group.addEventListener(NetStatusEvent.NET_STATUS, friendGroupStatusHandler);
			}
		}
		
		public function sendData(data : Object) : void
		{
			var message : Object = new Object;
			message.data = data;
			message.uniqueId = StringUtils.generateRandomString(64);
			_myGroup.post(message);	
		}
		
		private function friendGroupStatusHandler(event : NetStatusEvent) : void
		{
			if (event.info.code == "NetGroup.Connect.Success")
			{
				var group : NetGroup = event.info.group;
			//	if (group.estimatedMemberCount == 1)
			//	{
			//		group.close();
			//		return;
			//	}
				
			}
			dispatchEvent(event);
		}
		
	}
}