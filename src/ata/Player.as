package ata
{
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.ui.Keyboard;

    /**
     * ...
     * @author Matthew Hyndman
     */
    public class Player extends Entity
    {
        private var isJumping:Boolean = true;

        public var playerReal:DisplayObject;
        public var playerImag:MovieClip;
        private static const IMG_SCALE:Number = 0.7;

        private static const MAX_SPEED:Number = 250;
        private static const ACCEL:Number = 600;
        private static const DECEL:Number = 600;
        private static const JUMP:Number = 450;
        private static const GRAVITY:Number = 700;
        
        public function Player(x:int, y:int) {
            super(40*IMG_SCALE, 130*IMG_SCALE);
            this.position = new Vector2(x, y);
            this.x = x;
            this.y = y;

            playerReal = new PlayeRealWalk();
            playerImag = new PlayerImag();
            playerReal.scaleY = playerImag.scaleY = playerReal.scaleX = playerImag.scaleX = IMG_SCALE;
            
            // for now, show player as always real to show walk animation
            addDisplay(World.REALITY, playerReal);
            addDisplay(World.IMAGINATION, playerImag);
            
            //addRadialSubtractiveMask(World.REALITY, 300, 100);
            addRadialAdditiveMask(World.IMAGINATION, 900, false, 50);
        }

        override public function update(input:Input, dt:Number, level:Level):void {
            speed.y += GRAVITY * dt;

            if (input.isdown(Keyboard.SPACE) && !isJumping) {
                speed.y = -JUMP;
                isJumping = true;
            }

            if (input.isdown(Keyboard.A) || input.isdown(Keyboard.LEFT)) {
                speed.x = Math.max(-MAX_SPEED, speed.x - ACCEL * dt);
            } else if (speed.x < 0) {
                speed.x = Math.min(0, speed.x + DECEL * dt);
            }
            if (input.isdown(Keyboard.D) || input.isdown(Keyboard.RIGHT)) {
                speed.x = Math.min(MAX_SPEED, speed.x + ACCEL * dt);
            } else if (speed.x > 0) {
                speed.x = Math.max(0, speed.x - DECEL * dt);
            }
            if (speed.x < 0) {
                playerReal.scaleX = playerImag.scaleX = -IMG_SCALE;
            } else if (speed.x > 0) {
                playerReal.scaleX = playerImag.scaleX = IMG_SCALE;
            }
            var hitGround:Boolean = handleLevelCollision(dt, level.realityCollision)

            if (hitGround) {
                isJumping = false;
            }

            super.update(input, dt, level);
        }
    }
}
