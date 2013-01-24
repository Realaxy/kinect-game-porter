package org.realaxy.kinect.porter.room
{
	import org.realaxy.kinect.porter.room.events.KinectCursorPresenterEvent;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class KinectCursorView extends Sprite
	{
		[Inject]
		public var kinectCursorPresenter:KinectCursorPresenter;
		
		[Embed(source="/assets/hand-cursor.png")]
		private static const HAND_CURSOR:Class;
		
		private var _image:Image;
		
		[PostConstruct]
		public function initInstance():void
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			kinectCursorPresenter.addEventListener(KinectCursorPresenterEvent.UPDATE_POSITION, onChangeKinectCursor);			
			var texture:Texture = starling.textures.Texture.fromBitmap(new HAND_CURSOR(), false); 
			_image = new Image(texture);
			_image.width = 64;
			_image.height = 64;
			addChild(_image);
		}
		
		private function onAddedToStage(event:Event):void
		{
			kinectCursorPresenter.width = stage.width;
			kinectCursorPresenter.height = stage.height;
		}
		
		private function onChangeKinectCursor(event: Event):void
		{
			_image.x = kinectCursorPresenter.position.x;
			_image.y = kinectCursorPresenter.position.y;
		}
	}
}