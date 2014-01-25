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
			reality = new Level1Reality()
			reality.y = 400;
			//parent.addChild(reality)
			
			realityCollision = new Level1RealityHitbox()
			realityCollision.y = 500;
			parent.addChild(realityCollision)
		}
		
	}

}
