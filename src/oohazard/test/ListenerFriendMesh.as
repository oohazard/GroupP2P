package oohazard.test 
{
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetGroup;
	
	import oohazard.p2p.rendezvous.RendezVousService;
	import oohazard.utils.StringUtils;
	
	public class ListenerFriendMesh extends EventDispatcher
	{
		private var _applicationName : String;
		
		private var _rendezVousService : RendezVousService;
		
		private var _password : String;
		
		
		private var _myGroup : NetGroup;
		private var _myGroupSpec : GroupSpecifier;
		
		
		private var _friendGroups : Vector.<NetGroup>;
		
		public function ListenerFriendMesh(applicationName : String, rendezVousService : RendezVousService)
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
			//_myGroupSpec.routingEnabled = true;
			//_myGroupSpec.setPostingPassword(_password);
			//_myGroupSpec.setPublishPassword(_password);
			
			//_myGroup = new NetGroup(_rendezVousService.connection, _myGroupSpec.groupspecWithAuthorizations());
			//_myGroup.addEventListener(NetStatusEvent.NET_STATUS, myGroupStatusHandler);
			
			var groupString : String = "";
			
			// get list of friends and connect to their group
			var friendIds : Vector.<String> = new Vector.<String>;
			friendIds.push("id1");
			for each (var friendId : String in friendIds)
			{
				var friendGroupsSpec : GroupSpecifier = new GroupSpecifier(_applicationName + "/" + friendId);
				friendGroupsSpec.serverChannelEnabled = true;
				friendGroupsSpec.postingEnabled = true;
				//friendGroupsSpec.routingEnabled = true;
				var group : NetGroup = new NetGroup(_rendezVousService.connection, friendGroupsSpec.groupspecWithoutAuthorizations());
				group.addEventListener(NetStatusEvent.NET_STATUS, friendGroupStatusHandler);
				_friendGroups.push(group);
				
			}
			
			return groupString
		}
		
		public function sendData(data : Object) : void
		{
			_myGroup.post(data);	
		}
		
		private function friendGroupStatusHandler(event : NetStatusEvent) : void
		{
			dispatchEvent(event);
		}
		
	}
}