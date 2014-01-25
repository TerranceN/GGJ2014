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
			if (position.getY() + size.getY() < GameLogic.ground) {
				speed.setY(300);
			} else {
				speed.setY(0);
				position.setY(Math.min(GameLogic.ground - size.getY(), position.getY()));
			}
			speed.setX(0);
			if (input.isdown(Keyboard.A) || input.isdown(Keyboard.LEFT)) {
				speed.setX(speed.getX() - 200);
			}
			if (input.isdown(Keyboard.D) || input.isdown(Keyboard.RIGHT)) {
				speed.setX(speed.getX() + 200);
			}
			super.update(input, dt);
		}
	}
	
}