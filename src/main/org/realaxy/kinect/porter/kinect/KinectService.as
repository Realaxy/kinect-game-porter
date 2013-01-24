package org.realaxy.kinect.porter.kinect
{
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.PointCloudEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.UserEvent;
	
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.setInterval;
	
	import org.realaxy.kinect.porter.room.events.KinectServiceEvent;
	
	import starling.events.EventDispatcher;

	public class KinectService extends EventDispatcher
	{
		private static const REFRESH_STATUS_INTERVAL:int = 1000;
		private static const REFRESH_USERS_INTERVAL:Number = 1000/24;
		
		private var _device:Kinect;
		
		private var _invalideUser:Boolean = false;
		
		private var _depthBitmap:BitmapData;
		private var _rgbBitmap:BitmapData;
		
		private var _kinectSupported : Boolean = false;
		
		private var _started : Boolean = false;
		
		private var _depthResolution:Point = new Point(320, 240);
		private var _rgbResolution:Point = new Point(320, 240);
		private var _validateUserTimer:Timer;

		[PostConstruct]
		public function initInstance():void
		{
			followKinectStatus();
			
			_validateUserTimer = new Timer(REFRESH_USERS_INTERVAL);
			_validateUserTimer.start();
			_validateUserTimer.addEventListener(TimerEvent.TIMER, onValidateUserTimer);
		}
		
		private function get kinectSupported():Boolean
		{
			return _kinectSupported;
		}
		
		private function set kinectSupported(value:Boolean):void
		{
			if(_kinectSupported == value)
			{
				return;
			}
			
			_kinectSupported = value;
			
			dispatchEventWith(KinectServiceEvent.STATUS_CHANGE);
		}
		
		private function followKinectStatus():void
		{
			setInterval(refreshStatus, REFRESH_STATUS_INTERVAL);
		}
		
		private function refreshStatus():void
		{
			kinectSupported = isSupported();
		}
		
		private function isSupportedSafe():Boolean
		{
			try
			{
				return Kinect.isSupported();	
			}
			catch(e:Error)
			{
				
			}
			return false;
		}
		
		public function get users():Vector.<User>
		{
			return _device.users;
		}
		
		public function getNearestUser(withSkeleton:Boolean = true):User
		{
			var nearestUser:User;
			var nearestUserZ:Number = Number.MAX_VALUE;
			var users:Vector.<User> = _device.users; 
			for(var index:int = 0, count:int = users.length; index < count; index++) 
			{
				var user:User = users[index];
				var newZ : Number = user.position.world.z; 
				if(nearestUserZ > newZ && (user.hasSkeleton || !withSkeleton))
				{
					nearestUserZ = newZ;
					nearestUser = user;
				}				
			}
			
			return user;
		}
		
		public function get depth():BitmapData
		{
			return _depthBitmap;
		}
		
		public function get depthResolution():Point
		{
			return _depthResolution;
		}
		
		public function get rgb():BitmapData
		{
			return _rgbBitmap;
		}
		
		public function get rgbResolution():Point
		{
			return _rgbResolution;
		}
		
		public function isSupported():Boolean
		{
			return kinectSupported = isSupportedSafe();
		}
		
		public function get elevationAngle():Number
		{
			return _device.cameraElevationAngle; 
		}
		
		public function set elevationAngle(value:Number):void
		{
			_device.cameraElevationAngle = value;
		}
		
		public function start():void
		{
			if(_started)
			{
				return;
			}
			
			_started = true;
			
			startFollowKinect();
		}
		
		private function startFollowKinect():void
		{
			if (isSupportedSafe()) {
				
				_device = Kinect.getDevice();
				
				_device.addEventListener(CameraImageEvent.DEPTH_IMAGE_UPDATE, onDepthImageUpdate);
				_device.addEventListener(CameraImageEvent.RGB_IMAGE_UPDATE, onRGBImage); 
				_device.addEventListener(PointCloudEvent.POINT_CLOUD_UPDATE, onPointCloud);
				_device.addEventListener(UserEvent.USERS_ADDED, onUsersAdded);
				_device.addEventListener(UserEvent.USERS_REMOVED, onUsersRemoved);
				_device.addEventListener(UserEvent.USERS_UPDATED, onUsersUpdated);
				_device.addEventListener(UserEvent.USERS_WITH_SKELETON_ADDED, onUsersWithSkeletonAdded);
				_device.addEventListener(UserEvent.USERS_WITH_SKELETON_REMOVED, onUsersWithSkeletonRemoved);
				_device.addEventListener(DeviceEvent.STARTED, onDeviceStared);
				_device.addEventListener(DeviceEvent.STOPPED, onDeviceStoped);
				
				var settings:KinectSettings = new KinectSettings();
				settings.depthEnabled = true;
				settings.depthResolution = _depthResolution;
				settings.rgbEnabled = true;
				settings.rgbResolution = _rgbResolution;
				settings.pointCloudEnabled = true;
				settings.skeletonEnabled = true;
				settings.userEnabled = true;
				//settings.userMaskEnabled = true;
				_device.start(settings);
			}
			
		}
		
		protected function onDeviceStoped(event:DeviceEvent):void
		{
			dispatchEventWith(KinectServiceEvent.STOP);
		}
		
		protected function onDeviceStared(event:DeviceEvent):void
		{
			dispatchEventWith(KinectServiceEvent.START);
		}
		
		public function stop():void
		{
			if(!_started)
			{
				return;
			}
			
			_started = false;
			
			stopFollowKinect();
		}
		
		private function stopFollowKinect():void
		{
			_device.stop();
		}
		
		protected function onUsersAdded(event:UserEvent):void
		{
			invalidateUsers();
		}
		
		protected function onUsersRemoved(event:UserEvent):void
		{
			invalidateUsers();
		}
		
		protected function onUsersUpdated(event:UserEvent):void
		{
			invalidateUsers();
		}
		
		protected function onUsersWithSkeletonAdded(event:UserEvent):void
		{
			invalidateUsers();
		}
		
		protected function onUsersWithSkeletonRemoved(event:UserEvent):void
		{
			invalidateUsers();
		}
		
		private function invalidateUsers():void
		{
			if(_invalideUser)
			{
				return;
			}
			
			_invalideUser = true;
		}
		
		protected function onValidateUserTimer(event:TimerEvent):void
		{
			if(!_invalideUser)
			{
				return;
			}
			
			validateUsers();
		}
		
		private function validateUsers():void
		{
			dispatchEventWith(KinectServiceEvent.USERS_CHANGE);
			
			_invalideUser = false;
		}
		
		protected function onRGBImage(event:CameraImageEvent):void
		{
			_rgbBitmap = event.imageData;
		}
		
		protected function onPointCloud(event:PointCloudEvent):void
		{
			event.pointCloudRegions;
			event.pointCloudData;
		}
		
		protected function onDepthImageUpdate(event:CameraImageEvent):void {
			_depthBitmap = event.imageData;
			dispatchEvent(new KinectServiceEvent(KinectServiceEvent.DEPTH_VIEW_CHANGE));
		}
	}
}
