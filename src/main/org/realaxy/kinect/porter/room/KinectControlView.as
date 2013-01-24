package org.realaxy.kinect.porter.room
{
	import feathers.controls.Slider;
	import feathers.events.FeathersEventType;
	
	import org.realaxy.kinect.porter.room.events.KinectServiceEvent;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class KinectControlView extends Sprite
	{
		private var _slider:Slider;
		
		[Inject]
		public var kinectService:KinectService;
		
		[PostConstruct]
		public function initInstance():void
		{
			_slider = new Slider();
			_slider.addEventListener(FeathersEventType.END_INTERACTION, onChangeSlider);
			_slider.maximum = 90;
			_slider.minimum = -90;
			_slider.width = 200;
			_slider.validate();
			_slider.visible = false;
			addChild(_slider);
			
			kinectService.addEventListener(KinectServiceEvent.START, onKinectStart);
		}
		
		private function onKinectStart(event:Event):void
		{
			_slider.visible = true;
			_slider.value = kinectService.elevationAngle;
		}
		
		private function onChangeSlider(event:Event):void
		{
			kinectService.elevationAngle = _slider.value;
		}
	}
}