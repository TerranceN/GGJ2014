package ata.levels 
{
	import ata.*;
	import flash.display.DisplayObject;
	
	/**
     * ...
     * @author Ryan
     */
    public class Level2 extends Level 
    {
        
        public var wanderRight:Boolean = false;
        public var parentObj:Parent;
        public function Level2() 
        {
            super(new kitchen_reality(), new kitchen_reality_hitbox(), new kitchen_reality_platforms(),
                    new kitchen_imagination(), new kitchen_imagination_hitbox(), new kitchen_imagination_platforms());
			
        }
        
        public override function update(input:Input, dt:Number, level:Level):void 
        {
            if (GameLogic.instance.player.position.y > -75 && GameLogic.instance.player.position.x > 400)
            {
                GameLogic.instance.player.influencedBy[World.FORCE_REAL] = true;
            }
            else
            {
                GameLogic.instance.player.influencedBy[World.FORCE_REAL] = false;
            }
            
            if (wanderRight)
            {
                parentObj.displayObjects[World.REALITY][0].scaleX = 2.2;
                parentObj.position.x += 10;
            }
            else {
                parentObj.displayObjects[World.REALITY][0].scaleX = -2.2;
                parentObj.position.x -= 10;
            }
            
            if (parentObj.position.x < 1400)
            {
                wanderRight = true;
            }
            
            if (parentObj.position.x > 2500)
            {
                wanderRight = false;
            }
        }
        
        override public function setupLevel(logic:GameLogic):void
        {
            super.setupLevel(logic);
            
            parentObj = new Parent();
            parentObj.position.x = 1500;
            parentObj.position.y = -30;
            
            parentObj.displayObjects[World.REALITY][0].scaleX = 2.2;
            parentObj.displayObjects[World.REALITY][0].scaleY = 2.2;
            parentObj.bubble.scaleModifier = 2.2;
            
            parentObj.addInfluence(World.REALITY, 300)
            
            logic.addEntity(parentObj);
            
            var nextStar:Star = new Star();
            nextStar.position.x = 2500;
            nextStar.position.y = -150;
            logic.stars.push(nextStar);
            logic.addEntity(nextStar);
            
            nextStar = new Star();
            nextStar.position.x = 600;
            nextStar.position.y = -500;
            logic.stars.push(nextStar);
            logic.addEntity(nextStar);
            
            nextStar = new Star();
            nextStar.position.x = 3000;
            nextStar.position.y = -400;
            logic.stars.push(nextStar);
            logic.addEntity(nextStar);
        }
    }

}