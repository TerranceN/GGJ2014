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

        public function handleLevelCollision(dt:Number, displayObject:DisplayObject):Boolean {
            var diff:Point = new Point(vx * dt, vy * dt)

            var bounds = this.getRect(this.parent);

            var test = displayObject.hitTestPoint(bounds.x, bounds.y + bounds.height + diff.y, true);

            if (test) {
                if (vy > 0) {
                    var move:Number = 0
                    test = displayObject.hitTestPoint(bounds.x, bounds.y + bounds.height + move, true);
                    while (!test) {
                        test = displayObject.hitTestPoint(bounds.x, bounds.y + bounds.height + move, true);
                        move += 1;
                    }
                    vy = move / dt;
                } else {
                    vy = 0
                }
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
