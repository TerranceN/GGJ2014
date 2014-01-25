package ata
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;

    /**
     * ...
     * @author Matthew Hyndman
     */
    public class Entity extends Sprite
    {
        public var size:Vector2;
        public var speed:Vector2;
        public var position:Vector2;
        public var testPosition:Sprite;

        public function Entity(w:int, h:int) {
            position = new Vector2(0, 0);
            speed = new Vector2(0, 0);
            this.size = new Vector2(w, h);
            testPosition = new Sprite();

            testPosition.graphics.beginFill(0xff0000);
            testPosition.graphics.drawCircle(0, 0, 10);
        }

        public function update(input:Input, dt:Number, level:Level):void {
            position = position.add(speed.times(dt));
            x = position.x;
            y = position.y;
        }

        public function handleLevelCollision(dt:Number, displayObject:DisplayObject):Boolean {
            var diff:Vector2 = speed.times(dt)

            var checkPosition:Vector2 = new Vector2(displayObject.parent.x + position.x, displayObject.parent.y + position.y + size.y)
            var test = displayObject.hitTestPoint(checkPosition.x, checkPosition.y + diff.y, true);

            if (test) {
                testPosition.x = position.x
                testPosition.y = position.y + size.y + diff.y
                if (speed.y > 0) {
                    var move:Number = 0
                    test = displayObject.hitTestPoint(checkPosition.x, checkPosition.y + move, true);
                    while (!test) {
                        test = displayObject.hitTestPoint(checkPosition.x, checkPosition.y + move, true);
                        move += 1;
                    }
                    speed.y = move / dt;
                } else {
                    speed.y = 0
                }
                return true;
            }

            return false;
        }

        public function draw():void {
            graphics.lineStyle(1, 0x000000, 0.5);
            graphics.drawRect(0 ,0 , size.x, size.y);
        }
    }

}
