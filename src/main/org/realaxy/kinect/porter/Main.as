package org.realaxy.kinect.porter
{
	import feathers.controls.Button;
	import feathers.themes.MetalWorksMobileTheme;
	
	import org.realaxy.kinect.porter.kinect.KinectUserSerialize;
	import org.realaxy.kinect.porter.kinect.cursor.KinectCursorPresenter;
	import org.realaxy.kinect.porter.kinect.cursor.KinectCursorView;
	import org.realaxy.kinect.porter.room.GameStatusView;
	import org.realaxy.kinect.porter.room.KinectControlView;
	import org.realaxy.kinect.porter.room.KinectDepthView;
	import org.realaxy.kinect.porter.room.KinectRGBView;
	import org.realaxy.kinect.porter.room.KinectService;
	import org.realaxy.kinect.porter.room.KinectStatusView;
	import org.realaxy.kinect.porter.room.KinectUsersStatusView;
	import org.realaxy.kinect.porter.room.RoomModel;
	import org.realaxy.kinect.porter.room.RoomPresentation;
	import org.realaxy.kinect.porter.room.RoomView;
	import org.realaxy.kinect.porter.room.SocketService;
	import org.realaxy.kinect.porter.socket.SocketController;
	import org.swiftsuspenders.Injector;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Main extends Sprite
	{
		private var _kinectConnect : KinectService = new KinectService();
		
		[Inject]
		public var myRoomView:RoomView;
		
		[Inject]
		public var cursorView:KinectCursorView;
		
		[Inject]
		public var socket:SocketService;
		
		[Inject]
		public var socketController:SocketController;
		
		private var _injector:Injector;
		
		private var _theme:MetalWorksMobileTheme;
		private var _1PlayerButton:Button;
		private var _2PlayerButton:Button;
		
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
			_theme = new MetalWorksMobileTheme(this.stage, false);
			
			_1PlayerButton = new Button();
			_1PlayerButton.label = "1 player";
			addChild(_1PlayerButton);
			_1PlayerButton.validate();
			_1PlayerButton.x = (this.stage.stageWidth - _1PlayerButton.width) / 2 - 70;
			_1PlayerButton.y = (this.stage.stageHeight - _1PlayerButton.height) / 2;
			
			_2PlayerButton = new Button();
			_2PlayerButton.label = "2 player";
			addChild(_2PlayerButton);
			_2PlayerButton.validate();
			_2PlayerButton.x = (this.stage.stageWidth - _2PlayerButton.width) / 2 + 70;
			_2PlayerButton.y = (this.stage.stageHeight - _2PlayerButton.height) / 2;
			
			
//			//create a button and give it some text to display.
//			_button = new Button();
//			_button.label = "Click Me";			
//			addChild(_button);			
//			_button.validate();
//			
			
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
			_injector.map(KinectUsersStatusView);
			_injector.map(KinectCursorView).asSingleton();
			_injector.map(KinectCursorPresenter).asSingleton();
			_injector.map(KinectControlView);
			_injector.map(GameStatusView);
			_injector.map(SocketController);
			_injector.map(SocketService).asSingleton();
			_injector.map(KinectUserSerialize).asSingleton();
			
			_injector.injectInto(this);
			
			socket.start();
		}
		
		[PostConstruct]
		public function initInstance():void
		{
			addChild(myRoomView);
			
			addChild(cursorView);			
		}
	}
}