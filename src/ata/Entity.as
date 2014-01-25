package ata
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Matthew Hyndman
	 */
	public class Entity extends Sprite
	{
		public var size:Vector2;
		public var speed:Vector2;
		public var position:Vector2;
		
		public function Entity(w:int, h:int) {
			position = new Vector2(0, 0);
			speed = new Vector2(0, 0);
			this.size = new Vector2(w, h);
		}
		
		public function update(input:Input, dt:Number):void {
			position = position.add(speed.times(dt));
			x = position.x;
			y = position.y;
		}
		
		public function draw():void {
			graphics.lineStyle(1, 0x000000, 0.5);
			graphics.drawRect(0 ,0 , size.x, size.y);
		}
	}
	
}