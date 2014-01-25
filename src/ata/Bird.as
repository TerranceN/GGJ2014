package ata
{
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.ui.Keyboard;

    /**
     * ...
     * @author Matthew Hyndman
     */
    public class Bird extends Entity
    {

        public var imgReal:MovieClip;
        public var imgImag:MovieClip;
        private static const IMG_SCALE:Number = 0.7;
        private static const SPEED:Number = 300;
        
        public function Bird(x:int, y:int) {
            super(40*IMG_SCALE, 40*IMG_SCALE);
            this.position = new Vector2(x, y);
            speed.x = SPEED;
            this.x = x;
            this.y = y;

            imgReal = new BirdFly();
            imgImag = new BirdFly();
            imgReal.scaleY = imgImag.scaleY = imgReal.scaleX = imgImag.scaleX = IMG_SCALE;
            
            // for now, show player as always real to show walk animation
            addDisplay(World.REALITY, imgReal);
            addDisplay(World.IMAGINATION, imgImag);
        }

        override public function update(input:Input, dt:Number, level:Level):void {
            if (position.x > 300) {
                speed.x = -SPEED;
            } else if (position.x < -300) {
                speed.x = SPEED;
            }

            if (speed.x < 0) {
                imgReal.scaleX = imgImag.scaleX = IMG_SCALE;
            } else if (speed.x > 0) {
                imgReal.scaleX = imgImag.scaleX = -IMG_SCALE;
            }
            
            super.update(input, dt, level);
        }
    }
}
