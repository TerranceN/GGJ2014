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
		public var imaginationPlatforms:DisplayObject;
		public var imaginationCollision:DisplayObject;
		
        public var x1:int;
        public var x2:int;
        
        //, imagDeath:DisplayObject
		public function Level(real:DisplayObject, realHit:DisplayObject, realPlat:DisplayObject, imag:DisplayObject, imagHit:DisplayObject, imagPlat:DisplayObject) 
		{
            var bounds:Rectangle = realHit.getBounds(realHit);
            x1 = bounds.x;
            x2 = x1 + bounds.width;
            
            super(0, 0);
            position.y = 0;

            reality = real;
			addDisplay(World.REALITY, reality);
			    
            realityPlatforms = realPlat
			realityPlatforms.alpha = 0;
			addDisplay(World.REALITY, realityPlatforms);
            
            realityCollision = realHit;
            realityCollision.alpha = 0;
			addDisplay(World.REALITY, realityCollision);
            
            imagination = imag;
			addDisplay(World.IMAGINATION, imagination);
			    
            imaginationPlatforms = imagPlat
			imaginationPlatforms.alpha = 0;
			addDisplay(World.REALITY, imaginationPlatforms);
            
            imaginationCollision = imagHit;
            imaginationCollision.alpha = 0;
			addDisplay(World.REALITY, imaginationCollision);
		}
        
        public function setupLevel(logic:GameLogic):void
        {
            
        }
	}

}
