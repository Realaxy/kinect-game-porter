package org.realaxy.kinect.porter.room
{
	import com.eclecticdesignstudio.motion.Actuate;
	
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
			addChild(_image);
			
			_catchedTimer = new Label();
			_catchedTimer.x = 64;
			_catchedTimer.y = 32;
			_catchedTimer.visible = false;
			addChild(_catchedTimer);			
		}
		
		private function onClickStart(event:Event):void
		{
			trace("onClickStart");
			_catchedTimer.visible = true;
		}
		
		private function onClickProgress(event:Event):void
		{
			trace("onClickProgress", kinectCursorPresenter.clickProgress.toFixed(2));
			_catchedTimer.text = kinectCursorPresenter.clickProgress.toFixed(2);
			//_catchedTimer.width = 64;
			_catchedTimer.validate();
			clickAnimation();
		}
		
		private function clickAnimation():void
		{
			_image.width = 60;
			_image.height = 60;
			Actuate.tween(_image, 0.3, {width: 54, height: 54}).onComplete(function():void{
				Actuate.tween(_image, 0.3, {width: 64, height: 64});
			});
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