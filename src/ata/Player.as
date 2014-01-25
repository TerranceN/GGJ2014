package ata
{
    import flash.geom.Point;
	
	/**
	 * ...
	 * @author Matthew Hyndman
	 */
	public class Player extends Entity
	{
		private var isJumping:Boolean = true;
		
		public function Player(x:int, y:int) {
			super(30, 50);
			draw();
			this.x = x;
			this.y = y;
		}
		
		override public function update(input:Input, dt:Number, level:Level):void {
            vy += 980 * dt;
            
            if (input.isdown("Space") && !isJumping) {
                vy = -300;
                isJumping = true;
            }
            if (input.isdown("A")) {
                vx = - 200;
            } else if (input.isdown("D")) {
                vx = 200;
            } else {
                vx = 0;
            }

            var hitGround = handleLevelCollision(dt, level.realityCollision)

            if (hitGround) {
                isJumping = false;
            }

            super.update(input, dt, level);
		}
	}
	
}
