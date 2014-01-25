package ata
{
	
	/**
	 * ...
	 * @author Matthew Hyndman
	 */
	public class Player extends Entity
	{
		
		public function Player(x:int, y:int) {
			super(30, 50);
			draw();
			this.x = x;
			this.y = y;
		}
		
		override public function update(input:Input, dt:Number):void {
			if (y + h < GameLogic.ground) {
				vy = 300;
			} else {
				vy = 0;
				y = Math.min(GameLogic.ground - h, y);
			}
			if (input.isdown("A")) {
				vx = - 200;
			} else if (input.isdown("D")) {
				vx = 200;
			} else {
				vx = 0;
			}
			super.update(input, dt);
		}
	}
	
}