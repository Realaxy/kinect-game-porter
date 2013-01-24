package org.realaxy.kinect.porter.room
{
	import feathers.controls.Label;
	
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
		private var _catchedTimer:Label;
		
		[PostConstruct]
		public function initInstance():void
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			kinectCursorPresenter.addEventListener(KinectCursorPresenterEvent.UPDATE_POSITION, onChangeKinectCursor);			
			kinectCursorPresenter.addEventListener(KinectCursorPresenterEvent.DETECTED, onUserDetected);
			kinectCursorPresenter.addEventListener(KinectCursorPresenterEvent.LOST, onUserLost);
			
			kinectCursorPresenter.addEventListener(KinectCursorPresenterEvent.CLICK_START, onClickStart);
			kinectCursorPresenter.addEventListener(KinectCursorPresenterEvent.CLICK_PROGRESS, onClickProgress);
			kinectCursorPresenter.addEventListener(KinectCursorPresenterEvent.CLICK_DONE, onClickDone);
			kinectCursorPresenter.addEventListener(KinectCursorPresenterEvent.CLICK_BREAK, onClickBreak);
			
			var texture:Texture = starling.textures.Texture.fromBitmap(new HAND_CURSOR(), false); 
			
			_image = new Image(texture);
			_image.width = 64;
			_image.height = 64;
			_image.visible = false;
			
			_catchedTimer = new Label();
			_catchedTimer.x = 64;
			_catchedTimer.y = 32;
			_catchedTimer.visible = false;
			
			addChild(_image);
		}
		
		private function onClickStart(event:Event):void
		{
			trace("onClickStart");
			_catchedTimer.visible = true;
		}
		
		private function onClickProgress(event:Event):void
		{
			trace("onClickProgress", kinectCursorPresenter.clickProgress.toString());
			_catchedTimer.text = kinectCursorPresenter.clickProgress.toString();
		}
		
		private function onClickDone(event:Event):void
		{
			trace("onClickDone"); 
			_catchedTimer.visible = false;
		}
		
		private function onClickBreak(event:Event):void
		{
			trace("onClickBreak");
			_catchedTimer.visible = false;
		}
		
		private function onUserDetected(event:Event):void
		{
			_catchedTimer.visible = true;
			_image.visible = true;
		}
		
		private function onUserLost(event:Event):void
		{
			_catchedTimer.visible = false;
			_image.visible = false;
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