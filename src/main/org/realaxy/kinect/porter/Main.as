package org.realaxy.kinect.porter
{
	import feathers.controls.Button;
	import feathers.themes.MetalWorksMobileTheme;
	
	import org.realaxy.kinect.porter.room.KinectDepthView;
	import org.realaxy.kinect.porter.room.KinectRGBView;
	import org.realaxy.kinect.porter.room.KinectService;
	import org.realaxy.kinect.porter.room.KinectStatusView;
	import org.realaxy.kinect.porter.room.RoomModel;
	import org.realaxy.kinect.porter.room.RoomPresentation;
	import org.realaxy.kinect.porter.room.RoomView;
	import org.swiftsuspenders.Injector;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Main extends Sprite
	{
		private var _kinectConnect : KinectService = new KinectService();
		
		[Inject]
		public var myRoomView:RoomView;
		
		private var _injector:Injector;
		
		private var _theme:MetalWorksMobileTheme;
		private var _button:Button;
		
		public function Main() 
		{
			//we'll initialize things after we've been added to the stage
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/**
		 * Where the magic happens. Start after the main class has been added
		 * to the stage so that we can access the stage property.
		 */
		protected function addedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			//create the theme. this class will automatically pass skins to any
			//Feathers component that is added to the stage. you should always
			//create a theme immediately when your app starts up to ensure that
			//all components are properly skinned.
			_theme = new MetalWorksMobileTheme(this.stage);
			
			//create a button and give it some text to display.
			_button = new Button();
			_button.label = "Click Me";			
			addChild(_button);			
			_button.validate();
			
			//center the button
			_button.x = (this.stage.stageWidth - _button.width) / 2;
			_button.y = (this.stage.stageHeight - _button.height) / 2;
			
			initInjector();
			
			//TODO
		}
		
		public function stop():void
		{
			
		}
		
		private function initInjector():void
		{
			_injector = new Injector();
			_injector.map(RoomView);
			_injector.map(RoomPresentation).asSingleton();
			_injector.map(RoomModel).asSingleton();
			_injector.map(KinectService).asSingleton();
			_injector.map(KinectStatusView);
			_injector.map(KinectDepthView);
			_injector.map(KinectRGBView);
			
			_injector.injectInto(this);
		}
		
		[PostConstruct]
		public function initInstance():void
		{
			addChild(myRoomView);			
		}
	}
}