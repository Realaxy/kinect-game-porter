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
		
		[Inject]
		public var rgbView:KinectRGBView;
		
		[Inject]
		public var depthView:KinectDepthView;
		
		public function RoomView() 
		{
			
		}
		
		[PostConstruct]
		public function initInstance():void
		{
			presentation.startKinect();
			
			addChild(kinectStatusView);
			addChild(rgbView);
			rgbView.y = 20; 
			addChild(depthView);
			depthView.x = 320;
			depthView.y = 20;
		}
	}
}