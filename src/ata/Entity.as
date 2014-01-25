package ata
{
    import flash.display.DisplayObject;
    import flash.display.BlendMode;
    import flash.display.GradientType;
	import flash.display.Sprite;
    import flash.geom.Matrix;
	
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
        
        //MAP STRING -> DISPLAY OBJECT
        public var displayObjects:Object = {};
        
        //MAP STRING -> DISPLAY OBJECT
        public var additiveMasks:Object = {};
        
        //MAP STRING -> DISPLAY OBJECT
        public var subtractiveMasks:Object = {};
		
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
        
        public function handleLevelCollision(dt:Number, displayObject:DisplayObject):Boolean {
            var diff:Vector2 = speed.times(dt)

            var checkPosition:Vector2 = new Vector2(-GameLogic.camera.x + position.x, -GameLogic.camera.y + position.y )
            var test:Boolean = displayObject.hitTestPoint(checkPosition.x, checkPosition.y + diff.y, true);
            
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
