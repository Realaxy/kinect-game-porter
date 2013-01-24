package org.realaxy.kinect.porter.room.events
{
	import starling.events.Event;
	
	public class KinectCursorPresenterEvent extends Event
	{
		public static const UPDATE_POSITION:String = "updatePosition";
		public static const LOST:String = "lost";
		public static const DETECTED:String = "detected";
		
		public static const CLICK_START:String = "clickStart";
		public static const CLICK_PROGRESS:String = "clickProgress";
		public static const CLICK_DONE:String = "clickDone";
		public static const CLICK_BREAK:String = "clickBreak";
		
		public function KinectCursorPresenterEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}