package ata 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
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
		
		public function Level() 
		{
            super(0, 0);
			reality = new level1_reality();
			addDisplay(World.REALITY, reality);
			
			realityPlatforms = new level1_reality_platforms();
            realityPlatforms.alpha = 0;
			addDisplay(World.REALITY, realityPlatforms);
            
			realityCollision = new level1_reality_hitbox();
            realityCollision.alpha = 0;
			addDisplay(World.REALITY, realityCollision);
            
			imagination = new level_1_imagination();
			addDisplay(World.IMAGINATION, imagination);
		}
	}

}
