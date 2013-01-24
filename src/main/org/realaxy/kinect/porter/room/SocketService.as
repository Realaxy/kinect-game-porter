package org.realaxy.kinect.porter.room
{
	import flash.events.Event;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.IDataOutput;
	
	import starling.events.EventDispatcher;

	public class SocketService extends EventDispatcher
	{
		private var _socket:Socket = new Socket();
		
		private var _host:String = "10.0.1.28";
		private var _port:int = 4445;
		
		public function start():void
		{
			_socket.connect(_host, _port);
			_socket.addEventListener(Event.ACTIVATE, onActivate);
			_socket.addEventListener(Event.CLOSE, onClose);
			_socket.addEventListener(Event.CONNECT, onConnected);
			_socket.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onOutputProgress);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
		}
		
		protected function onOutputProgress(event:OutputProgressEvent):void
		{
			trace("onOutputProgress", event);
			
			var result:String = _socket.readUTFBytes(_socket.bytesAvailable);
			trace(result);
		}
		
		protected function onActivate(event:Event):void
		{
			trace("onActivate", event);
			// TODO Auto-generated method stub
			
			var result:String = _socket.readUTFBytes(_socket.bytesAvailable);
			trace(result);
		}
		
		protected function onClose(event:Event):void
		{
			trace("onClose", event);
			// TODO Auto-generated method stub
			
			var result:String = _socket.readUTFBytes(_socket.bytesAvailable);
			trace(result);
		}
		
		protected function onSocketData(event:ProgressEvent):void
		{
			trace("onSocketData", event);
			
			var result:String = _socket.readUTFBytes(_socket.bytesAvailable);
			trace(result);
		}
		
		protected function onConnected(event:Event):void
		{
			trace("onConnected", event);
			
			var result:String = _socket.readUTFBytes(_socket.bytesAvailable);
			trace(result);
		}
		
		public function stop():void
		{
			_socket.close();
		}
		
		public function sendString(value:String):void
		{
			if(!_socket.connected)
			{
				return;
			}
			
			_socket.writeUTFBytes(value);
			_socket.flush();
		}
		
		public function get dataOutput():IDataOutput
		{
			return _socket;
		}
		
		public function flush():void
		{
			if(!_socket.connected)
			{
				return;
			}
			
			trace("_socket.bytesPending", _socket.bytesPending);
			_socket.flush();
		}
	}
}