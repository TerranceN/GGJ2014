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

        private static const MAX_SPEED_REAL:Number = 150;
        private static const ACCEL_REAL:Number = 450;
        private static const DECEL_REAL:Number = 450;
        private static const JUMP_REAL:Number = 400;
        
        private static const MAX_SPEED_IMAG:Number = 300;
        private static const ACCEL_IMAG:Number = 850;
        private static const DECEL_IMAG:Number = 850;
        private static const JUMP_IMAG:Number = 550;
        
        private static var MAX_SPEED:Number = 250;
        private static var ACCEL:Number = 600;
        private static var DECEL:Number = 600;
        private static var JUMP:Number = 450;
        
        public function Player(x:int, y:int) {
            super(40*IMG_SCALE, 130*IMG_SCALE);
            this.position = new Vector2(x, y);
            this.x = x;
            this.y = y;

            playerReal = new PlayeRealWalk();
            playerImag = new PlayeRealWalk();
            playerReal.scaleY = playerImag.scaleY = playerReal.scaleX = playerImag.scaleX = IMG_SCALE;
            
            // for now, show player as always real to show walk animation
            addDisplay(World.REALITY, playerReal);
            addDisplay(World.IMAGINATION, playerImag);
            
            addRadialAdditiveMask(World.IMAGINATION, 900, false, 150);
        }

        override public function update(input:Input, dt:Number, level:Level):void {
            if (influencedBy[World.REALITY])
            {
                MAX_SPEED = MAX_SPEED_REAL;
                ACCEL = ACCEL_REAL;
                DECEL = DECEL_REAL;
                JUMP = JUMP_REAL;
            }
            else
            {
                MAX_SPEED = MAX_SPEED_IMAG;
                ACCEL = ACCEL_IMAG;
                DECEL = DECEL_IMAG;
                JUMP = JUMP_IMAG;
            }
            
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

            var hitGround:Boolean = handleLevelCollision(dt, level.realityCollision, mainCollisionPoints())
            hitGround = hitGround || handleLevelCollision(dt, level.realityPlatforms, platformCollisionPoints())

            if (hitGround) {
                isJumping = false;
            }

            super.update(input, dt, level);
            
            if (position.x < level.x1) {
                GameLogic.instance.setLevel(GameLogic.instance.levelNum - 1);
            } else if (position.x > level.x2) {
                GameLogic.instance.setLevel(GameLogic.instance.levelNum + 1);
            }
        }
    }
}
