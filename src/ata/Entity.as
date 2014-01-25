package ata
{
	import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.geom.Point;

    /**
     * ...
     * @author Matthew Hyndman
     */
    public class Entity extends Sprite
    {
        public var w:int;
        public var h:int;
        public var vx:Number;
        public var vy:Number;

        public function Entity(w:int, h:int) {
            this.w = w;
            this.h = h;
            vx = 0;
            vy = 0;
        }

        public function update(input:Input, dt:Number, level:Level):void {
            x = x + vx * dt;
            y = y + vy * dt;
        }

        public function handleLevelCollision(diff:Point, displayObject:DisplayObject):Boolean {
            var bounds = this.getRect(this.parent);

            var test = displayObject.hitTestPoint(bounds.x, bounds.y + bounds.height + diff.y, true);

            if (test) {
                vy = 0;
                return true;
            }

            return false;
        }

        public function draw():void {
            graphics.lineStyle(1, 0x000000);
            graphics.drawRect(0 ,0 , w, h);
        }
    }

}
