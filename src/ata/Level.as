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
		public var realityCollision:DisplayObject;
		
		public function Level(parent:Sprite) 
		{
            super(0, 0);
			reality = new level1_reality()
            position.y = 300;
			addDisplay(World.REALITY, reality);
			
			realityCollision = new level1_reality_hitbox()
			//parent.addChild(realityCollision)
		}
		
        override public function update(input:Input, dt:Number):void 
        {
            super.update(input, dt);
            
        }
	}

}
