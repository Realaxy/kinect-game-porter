package org.realaxy.kinect.porter.room
{
	import org.realaxy.kinect.porter.room.events.KinectServiceEvent;
	import org.realaxy.kinect.porter.room.events.RoomEvent;
	
	import starling.events.EventDispatcher;

	public class RoomPresentation extends EventDispatcher
	{
		[Inject]
		public var model:RoomModel;
		
		[Inject]
		public var kinectService:KinectService;
		
		public function RoomPresentation()
		{
			/*
			_depthBitmap = new Bitmap();
			addChild(_depthBitmap);
			
			_rgbBitmap = new Bitmap();
			_rgbBitmap.x = 320;
			
			addChild(_rgbBitmap);
			
			_kinectConnect.start();
			_kinectConnect.addEventListener(Event.CHANGE, onChangeKinect);
			*/
		}
		
		[PostConstruct]
		public function initInstance():void
		{
			kinectService.addEventListener(KinectServiceEvent.STATUS_CHANGE, onKinectServiceStatusChange);
		}
		
		private function onKinectServiceStatusChange(event:KinectServiceEvent):void
		{
			dispatchEventWith(RoomEvent.KINECT_STATUS_CHANGE);
		}
		
		public function hasKinect():Boolean
		{
			return kinectService.isSupported();
		}
		
		public function startKinect():void
		{
			kinectService.start();
		}
	}
}