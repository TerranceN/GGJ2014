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

        public var playerReal:MovieClip;
        public var playerImag:MovieClip;
        private static const IMG_SCALE:Number = 0.7;

        private static const MAX_SPEED:Number = 250;
        private static const ACCEL:Number = 600;
        private static const DECEL:Number = 600;
        private static const JUMP:Number = 450;
        
        private static const IDLE_FRAME:uint = 1;
        private static const WALK_FRAME:uint = 2;
        
        public function Player(x:int, y:int) {
            super(40*IMG_SCALE, 130*IMG_SCALE);
            this.position = new Vector2(x, y);
            this.x = x;
            this.y = y;

            playerReal = new RPlayer();
            playerImag = new IPlayer();
            playerReal.gotoAndStop(IDLE_FRAME);
            playerImag.gotoAndStop(IDLE_FRAME);
            
            playerReal.scaleY = playerImag.scaleY = playerReal.scaleX = playerImag.scaleX = IMG_SCALE;
            
            // for now, show player as always real to show walk animation
            addDisplay(World.REALITY, playerReal);
            addDisplay(World.IMAGINATION, playerImag);
            
            addRadialAdditiveMask(World.IMAGINATION, 700, false, 150);
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
            
            if (Math.abs(speed.x) < 100) {
                playerReal.gotoAndStop(IDLE_FRAME);
                playerImag.gotoAndStop(IDLE_FRAME);                
            } else {
                playerReal.gotoAndStop(WALK_FRAME);
                playerImag.gotoAndStop(WALK_FRAME);                
            }

            var hitGround:Boolean;
            if (influencedBy[World.REALITY]) {
                hitGround = handleLevelCollision(dt, level.realityCollision, mainCollisionPoints())
                hitGround = hitGround || handleLevelCollision(dt, level.realityPlatforms, platformCollisionPoints())
            }    else if (influencedBy[World.IMAGINATION]) {
                hitGround = handleLevelCollision(dt, level.realityCollision, mainCollisionPoints())
                hitGround = hitGround || handleLevelCollision(dt, level.realityPlatforms, platformCollisionPoints())
            }

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
