package org.realaxy.kinect.porter.room
{
	import starling.events.EventDispatcher;

	public class RoomPresentation extends EventDispatcher
	{
		[Inject]
		public var model:RoomModel;
		
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
		
		public function hasKinect():Boolean
		{
			return false;
		}
	}
}