package ata
{
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Matthew Hyndman
	 */
	public class Player extends Entity
	{
		
		public function Player(x:int, y:int) {
			super(30, 50);
			draw();
			this.position = new Vector2(x, y);
			this.x = x;
			this.y = y;
		}
		
		override public function update(input:Input, dt:Number):void {
			if (position.y + size.y < GameLogic.ground) {
				speed.y = 300;
			} else {
				speed.y = 0;
				position.y = Math.min(GameLogic.ground - size.y, position.y);
			}
			speed.x = 0;
			if (input.isdown(Keyboard.A) || input.isdown(Keyboard.LEFT)) {
				speed.x = speed.x - 200;
			}
			if (input.isdown(Keyboard.D) || input.isdown(Keyboard.RIGHT)) {
				speed.x = speed.x + 200;
			}
			super.update(input, dt);
		}
	}
	
}