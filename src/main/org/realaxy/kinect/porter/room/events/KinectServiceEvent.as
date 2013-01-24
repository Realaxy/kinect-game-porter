package org.realaxy.kinect.porter.room.events
{
	import starling.events.Event;
	
	public class KinectServiceEvent extends Event
	{
		public static const STATUS_CHANGE:String = "statusChange";
		public static const DEPTH_VIEW_CHANGE:String = "depthViewChange"
		public static const RGB_VIEW_CHANGE:String = "rgbViewChange"
		
		public function KinectServiceEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}