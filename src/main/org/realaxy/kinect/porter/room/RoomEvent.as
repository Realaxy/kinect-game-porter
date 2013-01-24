package org.realaxy.kinect.porter.room
{
	import starling.events.Event;
	
	public class RoomEvent extends starling.events.Event
	{
		public static const KINECT_STATUS_CHANGE:String = "KinectStatusChange";
		
		public function RoomEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}