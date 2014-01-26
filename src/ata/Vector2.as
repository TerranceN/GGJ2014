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

        public function Vector2(x: Number=NaN, y:Number=NaN) {
            this.x = x;
            this.y = y;

            if (isNaN(x)) {
                this.x = 0;
            }

            if (isNaN(y)) {
                this.y = this.x;
            }
        }

        public function add(v:Vector2):Vector2
        {
            return new Vector2(x + v.x, y + v.y);
        }

        public function vec2Times(other:Vector2):Vector2 {
            return new Vector2(x * other.x, y * other.y)
        }

        public function times(scalar:Number):Vector2 {
            return new Vector2(x * scalar, y * scalar);
        }

        public function length():Number {
            return Math.sqrt(lengthSquared())
        }

        public function lengthSquared():Number {
            return x*x + y*y;
        }

        public function normalize():Vector2 {
            var l = length()

            if (l > 0) {
                return new Vector2(x/l, y/l)
            } else {
                return new Vector2()
            }
        }

        public function filterWith(filter:Vector2):Vector2 {
            var newX = 0;
            var newY = 0;

            if (x * filter.x > 0) {
                newX = x;
            }

            if (y * filter.y > 0) {
                newY = y;
            }

            return new Vector2(newX, newY);
        }

        public function toString():String {
            return x + ", " + y
        }

        public function dot(other:Vector2):Number {
            return x*other.x + y*other.y
        }

        public function projectionOnto(other:Vector2):Vector2 {
            return other.times(dot(other) / (other.length() * other.length()))
        }

        public function rejectionOnto(other:Vector2):Vector2 {
            return add(projectionOnto(other).times(-1))
        }
    }
}
