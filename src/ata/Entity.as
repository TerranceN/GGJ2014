package ata
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Matthew Hyndman
	 */
	public class Entity extends Sprite
	{
		private var w:int;
		private var h:int;
		
		public function Entity(w:int, h:int) {
			this.w = w;
			this.h = h;
		}
		
		public function draw():void {
			graphics.lineStyle(1, 1);
			graphics.drawCircle(0, 0, 10);
		}
	}
	
}