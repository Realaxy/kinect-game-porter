package org.realaxy.kinect.porter.room
{
	import flash.display.Bitmap;
	
	import starling.display.Sprite;
	
	public class RoomView extends Sprite
	{
		private var _depthBitmap:Bitmap;
		private var _rgbBitmap:Bitmap;
		
		[Inject]
		public var presentation : RoomPresentation;
		
		[Inject]
		public var kinectStatusView : KinectStatusView;
		
		public function RoomView() 
		{
			
		}
		
		[PostConstruct]
		public function initInstance():void
		{
			addChild(kinectStatusView);
		}
	}
}