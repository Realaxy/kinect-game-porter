package org.realaxy.kinect.porter.room
{
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.PointCloudEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.UserEvent;
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;

	public class KinectService extends EventDispatcher
	{
		private var _device:Kinect;
		
		private var _invalideUser:Boolean = false;
		
		private var _depthBitmap:BitmapData;
		private var _rgbBitmap:BitmapData;
		
		public function get users():Vector.<User>
		{
			return _device.users;
		}
		
		public function get depth():BitmapData
		{
			return _depthBitmap;
		}
		
		public function get rgb():BitmapData
		{
			return _rgbBitmap;
		}
		
		public function start():void
		{
			startKinect();
		}
		
		public function stop():void
		{
			
		}
		
		private function startKinect():void
		{
			if (Kinect.isSupported()) {
				
				_device = Kinect.getDevice();
				
				_device.addEventListener(CameraImageEvent.DEPTH_IMAGE_UPDATE, onDepthImageUpdate);
				_device.addEventListener(CameraImageEvent.RGB_IMAGE_UPDATE, onRGBImage); 
				_device.addEventListener(PointCloudEvent.POINT_CLOUD_UPDATE, onPointCloud);
				_device.addEventListener(UserEvent.USERS_ADDED, onUsersAdded);
				_device.addEventListener(UserEvent.USERS_REMOVED, onUsersRemoved);
				_device.addEventListener(UserEvent.USERS_UPDATED, onUsersUpdated);
				_device.addEventListener(UserEvent.USERS_WITH_SKELETON_ADDED, onUsersWithSkeletonAdded);
				_device.addEventListener(UserEvent.USERS_WITH_SKELETON_REMOVED, onUsersWithSkeletonRemoved);
				
				var settings:KinectSettings = new KinectSettings();
				settings.depthEnabled = true;
				settings.pointCloudEnabled = true;
				settings.rgbEnabled = true;
				settings.rgbResolution.x = 320;
				settings.rgbResolution.y = 240;
				settings.skeletonEnabled = true;
				settings.userEnabled = true;
				//settings.userMaskEnabled = true;
				_device.start(settings);
			}
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
			
			var users:Vector.<User> = _device.users;
			
			for(var index:int = 0, count:int = users.length; index < count; index++)
			{
				var user:User = users[index];
				showUser(user);
			}
		}
		
		private function showUser(user:User):void
		{
			trace("user.framework: " + user.framework);
			trace("user.hasSkeleton:" + user.hasSkeleton);
			//user.position.
		}
		
		protected function onRGBImage(event:CameraImageEvent):void
		{
			_rgbBitmap = event.imageData;
		}
		
		protected function onPointCloud(event:PointCloudEvent):void
		{
			trace("pointCloudHandler");
			event.pointCloudRegions;
			event.pointCloudData;
		}
		
		protected function onDepthImageUpdate(event:CameraImageEvent):void {
			_depthBitmap = event.imageData;
		}
	}
}