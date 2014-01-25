package ata
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Matthew Hyndman
	 */
	public class Entity extends Sprite
	{
		public var w:int;
		public var h:int;
		public var vx:Number;
		public var vy:Number;
		
		public function Entity(w:int, h:int) {
			this.w = w;
			this.h = h;
			vx = 0;
			vy = 0;
		}
		
		public function update(input:Input, dt:Number):void {
			x = x + vx * dt;
			y = y + vy * dt;
		}
		
		public function draw():void {
			graphics.lineStyle(1, 0x000000);
			graphics.drawRect(0 ,0 , w, h);
		}
	}
	
}