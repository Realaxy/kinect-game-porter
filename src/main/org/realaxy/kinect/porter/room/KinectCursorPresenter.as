package org.realaxy.kinect.porter.room
{
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	
	import flash.display.Stage;
	import flash.geom.Point;
	
	import org.realaxy.kinect.porter.room.events.KinectCursorPresenterEvent;
	import org.realaxy.kinect.porter.room.events.KinectServiceEvent;
	
	import starling.events.EventDispatcher;
	
	public class KinectCursorPresenter extends EventDispatcher
	{
		[Inject]
		public var kinectService:KinectService;
		
		private var _mainUserActivate:Boolean = false;
		private var _mainUserID:uint;
		private var _position:Point;
		
		private var _width:int;
		private var _height:int;

		[PostConstruct]
		public function initInstance():void
		{
			kinectService.addEventListener(KinectServiceEvent.USERS_CHANGE, onUsersChange);
		}
		
		public function get width():int
		{
			return _width;
		}
		
		public function set width(value:int):void
		{
			_width = value;
		}
		
		public function get height():int
		{
			return _height;
		}
		
		public function set height(value:int):void
		{
			_height = value;
		}
		
		public function get position():Point
		{
			return _position;
		}
		
		private function onUsersChange():void
		{
			var user:User = getMainUser(true);
			if(user == null)
			{
				return;
			}
			
			//			var rightHandPosition:Vector3D = user.rightHand.position.world;
			//			var rightHandPositionRelative:Vector3D = user.rightHand.position.worldRelative;
			
			_position = user.rightHand.position.rgb.clone();
			
//			trace("x", user.position.rgb.x - user.rightHand.position.rgb.x);
//			trace("y", user.position.rgb.y - user.rightHand.position.rgb.y);
					
			_position.x = width * _position.x / kinectService.rgbResolution.x;
			_position.y = height * _position.y / kinectService.rgbResolution.y;
			
			dispatchEventWith(KinectCursorPresenterEvent.UPDATE_POSITION);
		}
		
		private function getMainUser(withSkeleton:Boolean):User
		{
			if(_mainUserActivate)
			{
				var users:Vector.<User> = kinectService.users; 
				for(var index:int = 0, count:int = users.length; index < count; index++) 
				{
					var user:User = users[index];
					if(_mainUserID == user.userID && (user.hasSkeleton || !withSkeleton))
					{
						return user;
					}
				}
			}
			
			return kinectService.getNearestUser();
		}
	}
}