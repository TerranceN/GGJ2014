package ata
{
    import flash.geom.Point;

    /**
     * ...
     * @author Matthew Hyndman
     */
    public class Vector2
    {
        public var x:Number;
        public var y:Number;

        public function Vector2(x: Number, y:Number) {
            this.x = x;
            this.y = y;
        }

        public function add(v:Vector2):Vector2
        {
            return new Vector2(x + v.x, y + v.y);
        }

        public function times(scalar:Number):Vector2 {
            return new Vector2(x * scalar, y * scalar);
        }
        
        public function diff(v:Vector2):Number
        {
            return Math.sqrt((v.x - x) * (v.x - x) + (v.y - y) * (v.y - y));
        }
    }
}
