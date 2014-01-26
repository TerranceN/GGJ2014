package ata
{
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.filters.BlurFilter;
    import flash.filters.DropShadowFilter;
    import flash.filters.ShaderFilter;
    import flash.ui.Keyboard;

    /**
     * ...
     * @author Matthew Hyndman
     */
    public class Bird extends Entity
    {

        public var imgReal:MovieClip;
        public var imgImag:MovieClip;
        private static const REAL_SCALE:Number = 0.7;
        private static const IMAG_SCALE:Number = 1.3;
        private static const SPEED:Number = 150;
        
        public function Bird(x:int, y:int) {
            super(40*IMAG_SCALE, 40*IMAG_SCALE);
            this.position = new Vector2(x, y);
            speed.x = SPEED;
            this.x = x;
            this.y = y;

            imgReal = new BirdFly();
            imgImag = new BirdFly();
            imgReal.scaleY = imgReal.scaleX = REAL_SCALE;
            imgImag.scaleY = imgImag.scaleX = IMAG_SCALE;
            // for now, show player as always real to show walk animation
            addDisplay(World.REALITY, imgReal);
            addDisplay(World.IMAGINATION, imgImag);
        }

        public function remove() {
            imgReal.parent.removeChild(imgReal)
            imgImag.parent.removeChild(imgImag)

            imgReal.visible = false
            imgImag.visible = false

            this.visible = false
        }

        override public function update(input:Input, dt:Number, level:Level):void {
            if (position.x > level.birdX2) {
                speed.x = -SPEED;
            } else if (position.x < level.birdX1) {
                speed.x = SPEED;
            }

            if (speed.x < 0) {
                imgReal.scaleX = REAL_SCALE;
                imgImag.scaleX = IMAG_SCALE;
            } else if (speed.x > 0) {
                imgReal.scaleX = -REAL_SCALE;
                imgImag.scaleX = -IMAG_SCALE;
            }
            
            super.update(input, dt, level);
        }
    }
}
