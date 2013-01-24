package org.realaxy.kinect.porter.socket
{
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import org.realaxy.kinect.porter.kinect.KinectUserSerialize;
	import org.realaxy.kinect.porter.room.KinectService;
	import org.realaxy.kinect.porter.room.SocketService;
	import org.realaxy.kinect.porter.room.events.KinectServiceEvent;
	
	import starling.events.Event;

	public class SocketController
	{
		private var _timer:Timer;
		
		private var _invalide:Boolean;
		
		[Inject]
		public var kinectService:KinectService;
		
		[Inject]
		public var userSerializer:KinectUserSerialize;
		
		[Inject]
		public var socketService:SocketService;
		
		[PostConstruct]
		public function initInstance():void
		{
			kinectService.addEventListener(KinectServiceEvent.USERS_CHANGE, onUsersChange);
			_timer = new Timer(1000 / 24);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
		
		private function onUsersChange(event:Event):void
		{
			invalide();
		}
		
		protected function onTimer(event:TimerEvent):void
		{
			if(_invalide)
			{
				sendUsers();
			}
		}
		
		private function invalide():void
		{
			if(_invalide)
			{
				return;
			}
			
			_invalide = true;
		}
		
		private function sendUsers():void
		{
			var users:Vector.<User> = kinectService.users;
			
			var bytes:ByteArray = new ByteArray();
			
			for(var index:int = 0, count:int = users.length; index < count; index++)
			{
				var user:User = users[index];
				userSerializer.toBytes(bytes, user);				
				userSerializer.toBytes(socketService.dataOutput, user);				
			}
			
			bytes.position = 0;
			var result:String = bytes.readUTFBytes(bytes.length);
			if(result.length > 0)
			{
				trace("result", result);				
			}
			
			//socketService.flush();			
		}
	}
}