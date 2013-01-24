package org.realaxy.kinect.porter.room
{
	import feathers.display.TiledImage;
	
	import org.realaxy.kinect.porter.room.events.KinectServiceEvent;
	
	import starling.display.Sprite;
	import starling.textures.Texture;
	import org.realaxy.kinect.porter.kinect.KinectService;
	
	public class KinectRGBView extends Sprite
	{
		[Inject]
		public var kinectService:KinectService;
		
		private var _image:TiledImage;
		private var _texture:Texture;
		
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
				_texture = starling.textures.Texture.fromBitmapData(kinectService.rgb, false); 
				_image = new TiledImage(_texture);
				addChild(_image);
			}
			else
			{
				_texture.dispose();
				_texture = starling.textures.Texture.fromBitmapData(kinectService.rgb, false);
				_image.texture = _texture; 				
			}
		}
	}
}