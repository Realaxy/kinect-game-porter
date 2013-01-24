package org.realaxy.kinect.porter.room
{
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import org.realaxy.kinect.porter.room.events.KinectCursorPresenterEvent;
	import org.realaxy.kinect.porter.room.events.KinectServiceEvent;
	
	import starling.events.EventDispatcher;
	
	public class KinectCursorPresenter extends EventDispatcher
	{
		private static const DELTA_CLICK:Number = 20;
		private static const LONG_DISTANCE_TO_CLEAR_CLICK:Number = 40;
		
		private static const CLICK_PROGRESS_DELTA:Number = 1000/60;
		private static const TIME_TO_CLICK:Number = 1*1000;
		
		[Inject]
		public var kinectService:KinectService;
		
		private var _mainUserActivate:Boolean = false;
		private var _mainUserID:uint;
		private var _position:Point;
		
		private var _width:int;
		private var _height:int;
		private var _worldPosition:Vector3D;
		private var _detected:Boolean;
		private var _lastPosition:Point;
		
		private var _clicking:Boolean;
		private var _timer:Timer;
		
		private var _startTime:int;
		private var _finishedTime:int;
		private var _clickProgress:Number;
		private var _lockClick:Boolean;

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
		
		public function get worldPosition():Vector3D
		{
			return _worldPosition;
		}
		
		private function get userDetected():Boolean
		{
			return _detected;
		}
		
		private function set userDetected(value:Boolean):void
		{
			if(_detected == value)
			{
				return;
			}
			
			_detected = value;
			
			if(value)
			{
				dispatchEventWith(KinectCursorPresenterEvent.DETECTED);
			}
			else
			{
				dispatchEventWith(KinectCursorPresenterEvent.LOST);
				
				stopClick(true);
			}
		}
		
		public function get clickProgress():Number
		{
			return _clickProgress;
		}
		
		private function onUsersChange():void
		{
			var user:User = getMainUser(true);
			if(user == null)
			{
				userDetected = false;
				return;
			}
			
			userDetected = true;
			
			//			var rightHandPosition:Vector3D = user.rightHand.position.world;
			//			var rightHandPositionRelative:Vector3D = user.rightHand.position.worldRelative;
			
			_position = user.rightHand.position.rgb.clone();
			
			_worldPosition = user.rightHand.position.world.clone();
			
//			trace("x", user.position.rgb.x - user.rightHand.position.rgb.x);
//			trace("y", user.position.rgb.y - user.rightHand.position.rgb.y);
					
			_position.x = width * _position.x / kinectService.rgbResolution.x;
			_position.y = height * _position.y / kinectService.rgbResolution.y;
			
			if(_lastPosition)
			{
//				trace(_position, _lastPosition);
				var distance : int = getDistanse(_position, _lastPosition);
				if(distance < DELTA_CLICK)
				{
					startClick();
				}
				else if(distance > LONG_DISTANCE_TO_CLEAR_CLICK)
				{
					clearClick();
				}
				else
				{
					stopClick(true);
				}				
			}
			
			_lastPosition = _position;
			
			dispatchEventWith(KinectCursorPresenterEvent.UPDATE_POSITION);
		}
		
		private function clearClick():void
		{
			_lockClick = false;
		}
		
		private function startClick():void
		{
			if(_clicking || _lockClick)
			{
				return;
			}
			
			_clicking = true;
			
			_timer = new Timer(CLICK_PROGRESS_DELTA);
			_timer.addEventListener(TimerEvent.TIMER, onClickProgress);
			_timer.start();
			
			_startTime = getTimer();
			_finishedTime = getTimer() + TIME_TO_CLICK;
			
			dispatchEventWith(KinectCursorPresenterEvent.CLICK_START);
		}
		
		private function stopClick(breaked:Boolean):void
		{
			if(!_clicking)
			{
				return;
			}
			
			_clicking = false;
			_timer.removeEventListener(TimerEvent.TIMER, onClickProgress);
			_timer.stop();
			
			if(breaked)
			{
				dispatchEventWith(KinectCursorPresenterEvent.CLICK_BREAK);				
			}
			else
			{
				dispatchEventWith(KinectCursorPresenterEvent.CLICK_DONE);			
			}
		}
		
		private function onClickProgress(event:TimerEvent):void
		{
			_clickProgress = (getTimer() - _startTime) / (_finishedTime - _startTime);
			if(_clickProgress>=1)
			{
				clickDone();
			}
			
			dispatchEventWith(KinectCursorPresenterEvent.CLICK_PROGRESS);
		}
		
		private function clickDone():void
		{
			stopClick(false);
			_lockClick = true;
		}
		
		private function getDistanse(point1:Point, point2:Point):Number
		{
			return Math.abs(point1.x - point2.x) + Math.abs(point1.y - point2.y); 
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