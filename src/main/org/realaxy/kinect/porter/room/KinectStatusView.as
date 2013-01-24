package org.realaxy.kinect.porter.room
{
	import feathers.controls.Label;
	
	import starling.display.Sprite;
	import org.realaxy.kinect.porter.room.events.RoomEvent;
	
	public class KinectStatusView extends Sprite
	{
		private var _hasKinect:Boolean;
		
		[Inject]
		public var presentation : RoomPresentation;
		
		private var _status:Label;
		
		[PostConstruct]
		public function initInstance():void
		{
			_status = new Label();
			addChild(_status);
			
			followKinectStats();
		}
		
		private function followKinectStats():void
		{
			hasKinect = false;
			hasKinect = true;
			
			invalidateKinectStats();
			presentation.addEventListener(RoomEvent.KINECT_STATUS_CHANGE, onKinectStatusChange);
		}
		
		private function invalidateKinectStats():void
		{
			hasKinect = presentation.hasKinect();
		}
		
		private function onKinectStatusChange(event:RoomEvent):void
		{
			invalidateKinectStats();
		}
		
		public function get hasKinect():Boolean
		{
			return _hasKinect;
		}
		
		public function set hasKinect(value:Boolean):void
		{
			if(_hasKinect == value)
			{
				return;
			}
			
			_hasKinect = value;
			
			_status.text = value?"has kinect":"hasn't kinect";
			_status.validate();
			
			trace("has Kinect", value);
		}
	}
}