package ata 
{
	/**
     * ...
     * @author Ryan
     */
    public class Parent extends Entity 
    {
        
        public var bubble:EffectBubble = null;
        public function Parent() 
        {
            super(0, 130);
			
            addDisplay(World.REALITY, new parent_reality());

            bubble = GameLogic.worldMap[World.IMAGINATION].addSubtractiveBubble(this, 68);
        }
        
    }

}
