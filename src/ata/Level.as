package ata 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Terrance
	 */
	public class Level 
	{
		public var reality:DisplayObject;
		public var realityCollision:DisplayObject;
		
		public function Level(parent:Sprite) 
		{
			reality = new level1_reality()
			reality.y = 500;
			parent.addChild(reality)
			
			realityCollision = new level1_reality_hitbox()
			realityCollision.y = 500;
			parent.addChild(realityCollision)
		}
		
	}

}
