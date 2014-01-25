package ata
{
    import flash.display.DisplayObject;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Matthew Hyndman
	 */
	public class Player extends Entity
	{
		var playerReal:DisplayObject;
        var playerImag:DisplayObject;
        
		public function Player(x:int, y:int) {
			super(40, 130);
			this.position = new Vector2(x, y);
			this.x = x;
			this.y = y;
			
            playerReal = new PlayerReal();
			playerImag = new PlayerImag();
			draw();
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
            if (speed.x < 0) {
                playerReal.scaleX = playerImag.scaleX = -1;
            } else if (speed.x > 0) {
                playerReal.scaleX = playerImag.scaleX = 1;
            }
			super.update(input, dt);
		}
        
        override public function draw():void {
            super.draw();
            playerReal.x = playerImag.x = size.x / 2;
            playerReal.y = playerImag.y = size.y;
            //addChild(playerReal);
            addChild(playerImag);
        }
	}
	
}