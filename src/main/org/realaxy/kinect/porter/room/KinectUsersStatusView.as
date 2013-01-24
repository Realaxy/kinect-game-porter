package org.realaxy.kinect.porter.room
{
	import feathers.controls.Label;
	
	import org.realaxy.kinect.porter.room.events.KinectServiceEvent;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import org.realaxy.kinect.porter.kinect.KinectService;
	
	public class KinectUsersStatusView extends Sprite
	{
		[Inject]
		public var kinectService:KinectService;
		
		private var _label:Label;
		
		[PostConstruct]
		public function initInstance():void
		{
			_label = new Label();
			_label.scaleX = 2;
			_label.scaleY = 2;
			addChild(_label);
			kinectService.addEventListener(KinectServiceEvent.USERS_CHANGE, onUsersChange);
		}
		
		private function onUsersChange(event:Event):void
		{
			_label.text = "users count : " + kinectService.users.length;
			_label.validate();
		}
	}
}
