package ata 
{
	import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Terrance
	 */
	public class Level extends Entity
	{
		public var reality:DisplayObjectContainer;
		public var realityCollision:DisplayObject;
		
		public function Level() 
		{
            super(0, 0);
			reality = new Scene1Real();
            /*
            trace("a");
            trace("reality has: ", reality.numChildren, " chidlren");
            for (var i:int = 0; i < reality.numChildren; i++) {
                var c:DisplayObject = reality.getChildAt(i);
                trace(c.x, c.y, c.width, c.rotation, c.scaleX);
            }
            */
            position.y = 300;
			addDisplay(World.REALITY, reality);
			
			realityCollision = new Scene1RealHit
            realityCollision.alpha = 0.5;
			addDisplay(World.REALITY, realityCollision);
		}
	}

}
