package ata 
{
	/**
     * ...
     * @author Ryan
     */
    public class Parent extends Entity 
    {
        
        public function Parent() 
        {
            super(0, 130);
			
            addDisplay(World.REALITY, new parent_reality());

            GameLogic.worldMap[World.IMAGINATION].addSubtractiveBubble(this, 68);
        }
        
    }

}
