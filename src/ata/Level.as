package ata 
{
	import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
    import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Terrance
	 */
	public class Level extends Entity
	{
		public var reality:DisplayObject;
		public var realityPlatforms:DisplayObject;
		public var realityCollision:DisplayObject;
        public var imagination:DisplayObject;
		
        public var x1:int;
        public var x2:int;
        
		public function Level(real:DisplayObject, realHit:DisplayObject, realPlat:DisplayObject, imag:DisplayObject) 
		{
            var bounds:Rectangle = realHit.getBounds(realHit);
            x1 = bounds.x;
            x2 = x1 + bounds.width;
            
            super(0, 0);
            position.y = 0;

            reality = real;
			addDisplay(World.REALITY, real);
			    
            realityPlatforms = realPlat
			realPlat.alpha = 0;
			addDisplay(World.REALITY, realPlat);
            
            realityCollision = realHit;
            realHit.alpha = 0;
			addDisplay(World.REALITY, realHit);
            
            imagination = imag;
			addDisplay(World.IMAGINATION, imag);
		}
        
        public function setupLevel(logic:GameLogic):void
        {
            
        }
	}

}
