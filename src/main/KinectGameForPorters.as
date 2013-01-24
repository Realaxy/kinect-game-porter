package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import org.realaxy.kinect.porter.Main;
	
	import starling.core.Starling;
	
	[SWF(frameRate="60", width="800", height="600", backgroundColor="#222222"))]
	public class KinectGameForPorters extends Sprite
	{
		
		private var _starling:Starling;
		
		public function KinectGameForPorters()
		{
			start();
		}
		
		public function start():void
		{
			Starling.multitouchEnabled = true; // for Multitouch Scene
			Starling.handleLostContext = true; // required on Windows, needs more memory
			
			_starling = new Starling(Main, stage);
			_starling.simulateMultitouch = true;
			_starling.enableErrorChecking = Capabilities.isDebugger;
			_starling.start();
			// this event is dispatched when stage3D is set up
			//_starling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			
			stage.addEventListener(flash.events.Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
			stage.addEventListener(flash.events.Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
		}
		
		private function stage_resizeHandler(event:flash.events.Event):void
		{
			_starling.stage.stageWidth = stage.stageWidth;
			_starling.stage.stageHeight = stage.stageHeight;
			
			const viewPort:Rectangle = _starling.viewPort;
			viewPort.width = stage.stageWidth;
			viewPort.height = stage.stageHeight;
			try
			{
				_starling.viewPort = viewPort;
			}
			catch(error:Error) {}
			//_starling.showStatsAt(HAlign.LEFT, VAlign.BOTTOM);
		}
		
		private function stage_deactivateHandler(event:flash.events.Event):void
		{
			_starling.stop();
			stage.addEventListener(flash.events.Event.ACTIVATE, stage_activateHandler, false, 0, true);
		}
		
		private function stage_activateHandler(event:flash.events.Event):void
		{
			stage.removeEventListener(flash.events.Event.ACTIVATE, stage_activateHandler);
			_starling.start();
		}
		
		private function onAddedToStage(event:Object):void
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
			start();
		}
	}
}