package ata
{
    import flash.display.DisplayObject;
    import flash.display.BlendMode;
    import flash.display.GradientType;
	import flash.display.Sprite;
    import flash.geom.Matrix;
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
        public static const MIN_WALL_WIDTH:Number = 20
        
        //MAP STRING -> DISPLAY OBJECT
        public var displayObjects:Object = {};
        
        //MAP STRING -> DISPLAY OBJECT
        public var additiveMasks:Object = {};
        
        //MAP STRING -> DISPLAY OBJECT
        public var subtractiveMasks:Object = { };
        
        public static const GRAVITY:Number = 700;
		
		public function Entity(w:int, h:int) {
            super();
			position = new Vector2(0, 0);
			speed = new Vector2(0, 0);
			this.size = new Vector2(w, h);
            testPosition = new Sprite();

            testPosition.graphics.beginFill(0xff0000);
            testPosition.graphics.drawCircle(0, 0, 10);
		}
        
        public function addDisplay(world:String, obj:DisplayObject):void
        {
            if (displayObjects[world] == undefined)
            {
                displayObjects[world] = new Vector.<DisplayObject>();
            }
            displayObjects[world].push(obj);
        }
        
        public function addAdditiveMask(world:String, obj:DisplayObject):void
        {
            if (additiveMasks[world] == undefined)
            {
                additiveMasks[world] = new Vector.<DisplayObject>();
            }
            additiveMasks[world].push(obj);
        }
        
        public function addSubtractiveMask(world:String, obj:DisplayObject):void
        {
            if (subtractiveMasks[world] == undefined)
            {
                subtractiveMasks[world] = new Vector.<DisplayObject>();
            }
            obj.blendMode = BlendMode.ALPHA;
            subtractiveMasks[world].push(obj);
        }
        
        public function addRadialAdditiveMask(world:String, radius:Number, fuzz:Number=100):void
        {
            var additiveMask:Sprite = new Sprite();
            var subtractiveMask:Sprite = new Sprite();
            
            trace(this.size.y)
            
            var m:Matrix = new Matrix();
            m.createGradientBox(radius*2, radius*2, 0, -radius - this.size.x/2, -radius -this.size.y/2);
            subtractiveMask.graphics.beginGradientFill(GradientType.RADIAL, [0, 0] , [1, 0], [255 - (255 * fuzz / radius), 255], m);
            subtractiveMask.graphics.drawCircle(-this.size.x/2, -this.size.y/2, radius);
            subtractiveMask.graphics.endFill();
            addSubtractiveMask(world, subtractiveMask);
            
            additiveMask.graphics.beginFill(0x000000);
            additiveMask.graphics.drawCircle(-this.size.x/2, -this.size.y/2, radius);
            additiveMask.graphics.endFill();
            addAdditiveMask(world, additiveMask);
        }
        
        public function addRadialSubtractiveMask(world:String, radius:Number, fuzz:Number=100):void
        {
            var subtractiveMask:Sprite = new Sprite();
            
            var m:Matrix = new Matrix();
            m.createGradientBox(radius*2, radius*2, 0, -radius-this.size.x/2, -radius-this.size.y/2);
            subtractiveMask.graphics.beginGradientFill(GradientType.RADIAL, [0, 0] , [0, 1], [255 - (255 * fuzz / radius), 254], m);
            subtractiveMask.graphics.drawCircle(-this.size.x/2, -this.size.y/2, radius);
            subtractiveMask.graphics.endFill();
            addSubtractiveMask(world, subtractiveMask);
        }
        
        public function getPointsInRange(start:Vector2, end:Vector2, step:Number):Array {
            var diff:Vector2 = end.add(start.times(-1));
            var segment:Vector2 = diff.normalize()
            var length:Number = diff.length()
            var output:Array = new Array();

            var lengthSoFar:Number = 0;

            while (lengthSoFar <= length) {
                output.push(start.add(segment.times(lengthSoFar)))
                lengthSoFar += step
            }

            return output
        }

        public function findContactPoint(displayObject:DisplayObject, hit:Vector2, miss:Vector2):Vector2 {
            var hitPoint:Vector2 = hit
            var missPoint:Vector2 = miss
            var length:Number = Number.MAX_VALUE;

            while(length > 0.1) {
                var mid:Vector2 = missPoint.add(hitPoint.add(missPoint.times(-1)).times(0.5))

                var test:Boolean = displayObject.hitTestPoint(mid.x, mid.y, true);

                if (test) {
                    hitPoint = mid
                } else {
                    missPoint = mid
                }

                var diff:Vector2 = hitPoint.add(missPoint.times(-1))
                length = diff.length()
            }

            return missPoint
        }

        public function makeTypePointPair(type:String, points:Array):Dictionary {
            var dict:Dictionary = new Dictionary();
            dict["type"] = type;
            dict["points"] = points;
            return dict;
        }

        public function mainCollisionPoints():Array {
            var wallPointStartHeight:Number = 20

            return new Array(
                makeTypePointPair(
                    "bottom_middle",
                    new Array(new Vector2(0, 0))
                ),
                makeTypePointPair(
                    "right",
                    getPointsInRange(
                        new Vector2(size.x / 2, -wallPointStartHeight),
                        new Vector2(size.x / 2, -size.y),
                        MIN_WALL_WIDTH - 0.1
                    )
                ),
                makeTypePointPair(
                    "left",
                    getPointsInRange(
                        new Vector2(-size.x / 2, -wallPointStartHeight),
                        new Vector2(-size.x / 2, -size.y),
                        MIN_WALL_WIDTH - 0.1
                    )
                ),
                makeTypePointPair(
                    "top_middle",
                    new Array(new Vector2(0, -size.y))
                )
            )
        }

        public function platformCollisionPoints():Array {
            return new Array(
                makeTypePointPair(
                    "bottom_middle",
                    new Array(new Vector2(0, 0))
                )
            )
        }

        public function handleLevelCollision(dt:Number, displayObject:DisplayObject, collisionPoints:Array):Boolean {
            var result:Boolean = false;
            var diff:Vector2 = speed.times(dt)
            var contact:Vector2

            for each (var dict:Dictionary in collisionPoints) {
                var key:String = dict["type"]
                var pointList:Array = dict["points"];
                var filteredDiff:Vector2 = new Vector2()

                if (key == "bottom_middle") {
                    if (diff.y >= 0) {
                        filteredDiff = new Vector2(0, diff.y)
                    } else {
                        filteredDiff = null
                    }
                } else if (key == "right") {
                    if (diff.x >= 0) {
                        filteredDiff = new Vector2(diff.x, 0)
                    } else {
                        filteredDiff = null
                    }
                } else if (key == "left") {
                    if (diff.x <= 0) {
                        filteredDiff = new Vector2(diff.x, 0)
                    } else {
                        filteredDiff = null
                    }
                } else if (key == "top_middle") {
                    if (diff.y <= 0) {
                        filteredDiff = new Vector2(0, diff.y)
                    } else {
                        filteredDiff = null
                    }
                }

                if (filteredDiff != null) {
                    for each (var testPoint:Vector2 in pointList) {
                        // if hitting at current location
                            // find point where not hitting
                            // binary search for contact point
                            // set appropriate velocity to 0
                        // if about to hit
                            // find point where not hitting
                            // binary search for contact point
                            // set appropriate velocity to 0

                        var parentPosition:Vector2 = new Vector2(-GameLogic.camera.x, -GameLogic.camera.y);
                        var currentPosition:Vector2 = parentPosition.add(position.add(testPoint));
                        var test:Boolean = displayObject.hitTestPoint(currentPosition.x, currentPosition.y, true);

                        if (test) {
                            var movement:Vector2 = new Vector2()
                            var move:Vector2 = new Vector2()

                            if (key == "bottom_middle") {
                                move = new Vector2(0, -10);
                                speed.y = 0
                                result = true;
                            } else if (key == "right") {
                                move = new Vector2(-10, 0)
                                speed.x = 0;
                            } else if (key == "left") {
                                move = new Vector2(10, 0)
                                speed.x = 0;
                            } else if (key == "top_middle") {
                                move = new Vector2(0, 10)
                                speed.y = 0
                            }

                            while (test) {
                                test = displayObject.hitTestPoint(currentPosition.x + movement.x, currentPosition.y + movement.y, true);
                                movement = movement.add(move)
                            }

                            contact = findContactPoint(displayObject, currentPosition, currentPosition.add(move))
                            position = contact.add(parentPosition.add(testPoint).times(-1))
                            x = position.x
                            y = position.y
                        } else {
                            var points:Array = getPointsInRange(currentPosition.add(filteredDiff), currentPosition, MIN_WALL_WIDTH - 0.1)

                            for (var i:int = points.length - 1; i >= 0; i--) {
                                test = displayObject.hitTestPoint(points[i].x, points[i].y, true);

                                if (test) {
                                    if (key == "bottom_middle") {
                                        speed.y = 0
                                        result = true;
                                    } else if (key == "right") {
                                        speed.x = 0;
                                    } else if (key == "left") {
                                        speed.x = 0;
                                    } else if (key == "top_middle") {
                                        speed.y = 0
                                    }

                                    contact = findContactPoint(displayObject, currentPosition, points[i])
                                    position = contact.add(parentPosition.add(testPoint).times(-1))
                                    x = position.x
                                    y = position.y

                                    break
                                }
                            }
                        }
                    }
                }
            }


            return result;
        }
		
		public function update(input:Input, dt:Number, level:Level):void {
			position = position.add(speed.times(dt));
			//x = position.x;
			//y = position.y;
            var world:World;
            var worldString:String;
            var objects:Vector.<DisplayObject>;
            var displayObject:DisplayObject;
            for (worldString in displayObjects)
            {
                objects = displayObjects[worldString];
                for each (displayObject in objects)
                {
                    displayObject.x = position.x;
                    displayObject.y = position.y;
                }
            }
            
            for (worldString in additiveMasks)
            {
                objects = additiveMasks[worldString];
                for each (displayObject in objects)
                {
                    displayObject.x = position.x;
                    displayObject.y = position.y;
                }
            }
            
            for (worldString in subtractiveMasks)
            {
                objects = subtractiveMasks[worldString];
                for each (displayObject in objects)
                {
                    displayObject.x = position.x;
                    displayObject.y = position.y;
                }
            }
		}
	}
	
}
