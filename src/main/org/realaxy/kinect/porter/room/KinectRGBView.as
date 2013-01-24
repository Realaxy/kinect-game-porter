package org.realaxy.kinect.porter.room
{
	import feathers.display.TiledImage;
	
	import org.realaxy.kinect.porter.room.events.KinectServiceEvent;
	
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class KinectRGBView extends Sprite
	{
		[Inject]
		public var kinectService:KinectService;
		
		private var _image:TiledImage;
		
		public function KinectRGBView()
		{
			super();
		}
		
		[PostConstruct]
		public function initInstance():void
		{
			kinectService.addEventListener(KinectServiceEvent.DEPTH_VIEW_CHANGE, onDepthViewChange);
		}
		
		private function onDepthViewChange():void
		{
			if(!kinectService.depth)
			{
				return;
			}
			
			if(_image == null)
			{
				_image = new TiledImage(starling.textures.Texture.fromBitmapData(kinectService.rgb));
				addChild(_image);
			}
			else
			{
				_image.texture = starling.textures.Texture.fromBitmapData(kinectService.rgb);				
			}
		}
	}
}