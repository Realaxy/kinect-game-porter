package org.realaxy.kinect.porter.room.events
{
	import starling.events.Event;
	
	public class KinectCursorPresenterEvent extends Event
	{
		public static const UPDATE_POSITION:String = "updatePosition";
		
		public function KinectCursorPresenterEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}