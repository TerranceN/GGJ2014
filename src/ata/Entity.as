package ata
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.utils.Dictionary;

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

        public function getPointsInRange(start:Vector2, end:Vector2, step:Number):Array {
            var diff = end.add(start.times(-1));
            var segment = diff.normalize()
            var length = diff.length()
            var output = new Array()

            var lengthSoFar = 0

            while (lengthSoFar <= length) {
                output.push(segment.times(lengthSoFar))
                lengthSoFar += step
            }

            return output
        }

        public function findContactPoint(displayObject:DisplayObject, hit:Vector2, miss:Vector2):Vector2 {
            var hitPoint = hit
            var missPoint = miss
            var length = 99999

            while(length > 0.1) {
                var mid = missPoint.add(hitPoint.add(missPoint.times(-1)).times(0.5))

                var test = displayObject.hitTestPoint(mid.x, mid.y, true);

                if (test) {
                    hitPoint = mid
                } else {
                    missPoint = mid
                }

                var diff = hitPoint.add(missPoint.times(-1))
                length = diff.length()
            }

            return missPoint
        }

        public function handleLevelCollision(dt:Number, displayObject:DisplayObject):Boolean {
            var result:Boolean = false;
            var diff:Vector2 = speed.times(dt)

            var testPoints:Dictionary = new Dictionary()
            testPoints["bottom_middle"] = new Array(
                new Vector2(size.x / 2, size.y)
            )

            for (var key:Object in testPoints) {
                var pointList:Array = testPoints[key];
                var filteredDiff = new Vector2()

                if (key == "bottom_middle") {
                    if (diff.y > 0) {
                        filteredDiff = new Vector2(0, diff.y)
                    } else {
                        filteredDiff = new Vector2()
                    }
                }

                for each (var testPoint:Vector2 in pointList) {
                    // if hitting at current location
                        // find point where not hitting
                        // binary search for contact point
                        // set appropriate velocity to 0
                    // if about to hit
                        // find point where not hitting
                        // binary search for contact point
                        // set appropriate velocity to 0

                    var parentPosition:Vector2 = new Vector2(displayObject.parent.x, displayObject.parent.y);
                    var currentPosition:Vector2 = parentPosition.add(position.add(testPoint));
                    var test = displayObject.hitTestPoint(currentPosition.x, currentPosition.y, true);

                    if (test) {
                        var movement = new Vector2()
                        var move = new Vector2()

                        if (key == "bottom_middle") {
                            move = new Vector2(0, -10);
                            speed.y = 0
                            result = true;
                        }

                        while (test) {
                            var test = displayObject.hitTestPoint(currentPosition.x + movement.x, currentPosition.y + movement.y, true);
                            movement = movement.add(move)
                        }

                        var contact = findContactPoint(displayObject, currentPosition, currentPosition.add(move))
                        position = contact.add(parentPosition.add(testPoint).times(-1))
                        x = position.x
                        y = position.y
                    } else {
                    }
                }
            }


            return result;
        }

        public function draw():void {
            graphics.lineStyle(1, 0x000000, 0.5);
            graphics.drawRect(0 ,0 , size.x, size.y);
        }
    }

}
