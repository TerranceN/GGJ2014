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
        private var freeFell:Boolean = false;

        public var playerReal:MovieClip;
        public var playerImag:MovieClip;
        public var bubble:EffectBubble = null;
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

            bubble = GameLogic.worldMap[World.IMAGINATION].addAdditiveBubble(this, 300);
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
                freeFell = false;
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
            var hitPlatform:Boolean;
            if (influencedBy[World.REALITY]) {
                hitGround = handleLevelCollision(dt, level.realityCollision, mainCollisionPoints())
                hitPlatform = handleLevelCollision(dt, level.realityPlatforms, platformCollisionPoints())
            }    else {
                hitGround = handleLevelCollision(dt, level.imaginationCollision, mainCollisionPoints())
                hitPlatform = handleLevelCollision(dt, level.imaginationPlatforms, platformCollisionPoints())
            }

            if (hitGround || hitPlatform) {
                isJumping = false;
            }
            
            if (speed.y > 1 && !hitPlatform)
            {
                freeFell = true;
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
