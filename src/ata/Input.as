package ata
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Matthew Hyndman
	 */
	public class Input 
	{
		public var keys:Dictionary = new Dictionary();
		
		private static const pressed:uint = 0;
		private static const released:uint = 1;
		private static const up:uint = 2;
		public static const down:uint = 3;
        private var stage:Stage;
		private var oldmousex:Number;
		private var oldmousey:Number;
		public var dmx:Number;
		public var dmy:Number;
		
		public var dt:Number;
		public static var MOUSE_KEY:uint = 0;
		
		public function Input(stage:Stage):void {
			this.stage = stage;
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keydown);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, keyup);
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, mousedown);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, mouseup);

			//have your main ui object call update before input calls update or else justpressed will be updated to down before the isjustpressed? test.
			//this.stage.addEventListener(Event.ENTER_FRAME,update);
			oldmousex = stage.mouseX;
			oldmousey = stage.mouseY;
		}
		
		public static function keyfromcode(code:uint):String {
			var key:String;
			switch (code) {
				case 191:
					key = "/"; break;
				case 222:
					key = "'"; break;
				case Keyboard.ESCAPE:
					key = "ESC"; break;
				case Keyboard.CONTROL:
					key = "Ctrl"; break;
				case Keyboard.SHIFT:
					key = "Shift"; break;
				case Keyboard.ENTER:
					key = "Enter"; break;
				case Keyboard.UP:
					key = "UP"; break;
				case Keyboard.DOWN:
					key = "DOWN"; break;
				case Keyboard.LEFT:
					key = "LEFT"; break;
				case Keyboard.RIGHT:
					key = "RIGHT"; break;
				case Keyboard.SPACE:
					key = "Space"; break;
				default: 
					key = String.fromCharCode(code);
			}
			return key;
		}
		private function keydown(e:KeyboardEvent):void {
			if (! isdown(e.keyCode)) keys[e.keyCode] = pressed;
		}
		private function keyup(e:KeyboardEvent):void {
			if (isdown(e.keyCode)) keys[e.keyCode] = released;
		}
		private function mousedown(e:MouseEvent):void {
			if (isdown(MOUSE_KEY)) keys[MOUSE_KEY] = pressed;
		}
		private function mouseup(e:MouseEvent):void {
			if (isdown(MOUSE_KEY)) keys[MOUSE_KEY] = released;
		}
		public function update(newdt:Number):void {
			dt = newdt;
			dmx = stage.mouseX - oldmousex;
			dmy = stage.mouseY - oldmousey;
			oldmousex = stage.mouseX;
			oldmousey = stage.mouseY;
            
			for (var key:String in keys) {
				switch (keys[key]) {
					case released:
						keys[key] = up;
						break;
					case pressed:
						keys[key] = down;
						break;
				}
			}
		}
		
		public function isdown(key:uint):Boolean {
			return keys[key] == down || keys[key] == pressed;
		}
		public function justpressed(key:uint):Boolean {
			return keys[key] == pressed;
		}
		public function justreleased(key:uint):Boolean {
			return keys[key] == released;
		}
		
		//call after a justpressed result
		public function presshandled(key:uint):void {
			keys[key] = down;
		}
	}
	
}