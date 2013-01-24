package org.realaxy.kinect.porter.room.events
{
	import starling.events.Event;
	
	public class KinectServiceEvent extends Event
	{
		public static const STATUS_CHANGE:String = "statusChange";
		public static const DEPTH_VIEW_CHANGE:String = "depthViewChange";
		public static const RGB_VIEW_CHANGE:String = "rgbViewChange";
		
		public static const USERS_CHANGE:String = "usersChange";
		
		public static const START:String = "start";
		public static const STOP:String = "stop";
		
		
		public function KinectServiceEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}