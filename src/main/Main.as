package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import org.realaxy.kinect.porter.EmbeddedAssets;
	import org.realaxy.kinect.porter.Game;
	
	import starling.core.Starling;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	[SWF(frameRate="60", width="800", height="600", backgroundColor="#222222"))]
	public class Main extends Sprite
	{
		// Startup image for SD screens
		[Embed(source="../../assets/background.jpg")]
		private static var Background:Class;
		
		private var _starling:Starling;
		
		public function Main()
		{
			start();
		}
		
		public function start():void
		{
			Starling.multitouchEnabled = true; // for Multitouch Scene
			Starling.handleLostContext = true; // required on Windows, needs more memory
			
			_starling = new Starling(Game, stage);
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
			this._starling.stage.stageWidth = this.stage.stageWidth;
			this._starling.stage.stageHeight = this.stage.stageHeight;
			
			const viewPort:Rectangle = this._starling.viewPort;
			viewPort.width = this.stage.stageWidth;
			viewPort.height = this.stage.stageHeight;
			try
			{
				this._starling.viewPort = viewPort;
			}
			catch(error:Error) {}
			//this._starling.showStatsAt(HAlign.LEFT, VAlign.BOTTOM);
		}
		
		private function stage_deactivateHandler(event:flash.events.Event):void
		{
			this._starling.stop();
			this.stage.addEventListener(flash.events.Event.ACTIVATE, stage_activateHandler, false, 0, true);
		}
		
		private function stage_activateHandler(event:flash.events.Event):void
		{
			this.stage.removeEventListener(flash.events.Event.ACTIVATE, stage_activateHandler);
			this._starling.start();
		}
		
		private function onAddedToStage(event:Object):void
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
			start();
		}
	}
}