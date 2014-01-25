package ata 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Matthew Hyndman
	 */
	
	public class GameLogic extends Sprite
	{
		//[Embed(source = "../../../assets/tilemap/tilemap.png")]
		//private var Tiles:Class;
		
		private const cameraOffset:Point = new Point(400, 450);
		private const cameraVelocity:Point = new Point(0, 0);
		private const camera:Point = new Point(0, 0);
		
		public var Paused:Boolean = false;
		public var dt:Number;
		public var totaltime:Number = 0;
		
		public var overtime:Number = 0;
		public static var T:Number = 0.02; // time between fixed update frames
		public static var ground:int = 400;
		private var w:int;
		private var h:int;
		public var input:Input;
		
		private var player:Player;
		
		public function GameLogic(w:int, h:int, input:Input) 
		{
			this.w = w;
			this.h = h;
			this.input = input;
			
			addEventListener(Event.ENTER_FRAME, update);
			//
			graphics.lineStyle(2, 0);
			graphics.moveTo(0, ground);
			graphics.lineTo(w, ground);
			
			player = new Player(w/2, h/2);
			addChild(player);
		}
		
		public function update(dt:Number):void {
			var t:uint = getTimer();
			dt =  Math.min(0.1, (t - totaltime) / 1000);
			totaltime = t;
			
			if (!Paused)
			{
				overtime = overtime + dt;
				while (overtime > T) //as soon as reach last frame, game is done. stop updating.
				{
					overtime = overtime - T;
					fixedupdate(T);
					input.update(T);
				}
				updateHUD();
			}
		}
		
		private function updateCamera():void
		{
			var cameraVelocityDelta:Point = new Point();
			cameraVelocityDelta.x = (player.x - cameraOffset.x - camera.x) / 3;
			cameraVelocityDelta.y = (player.y - cameraOffset.y - camera.y) / 3;
			
			if (cameraVelocityDelta.x * cameraVelocity.x < 0)
			{
				cameraVelocity.x = 0;
			}
			else
			{
				cameraVelocity.x += cameraVelocityDelta.x;
			}
			
			if (cameraVelocityDelta.y * cameraVelocity.y < 0)
			{
				cameraVelocity.y = 0;
			}
			else
			{
				cameraVelocity.y += cameraVelocityDelta.y;
			}
			
			camera.x += cameraVelocity.x * dt;
			camera.y += cameraVelocity.y * dt;
			
			cameraVelocity.x *= 0.9;
			cameraVelocity.y *= 0.9;
			
			this.x = -camera.x
			this.y = -camera.y
		}
		
		private function updateHUD():void 
		{
		}
		
		public function fixedupdate(dt:Number):void //dt is 1/50th of a second
		{
			player.update(input, dt);
		}
		
		public function stoplistening():void
		{
			this.removeEventListener(Event.ENTER_FRAME, update);
		}
	}
}