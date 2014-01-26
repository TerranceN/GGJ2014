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
            super(0, 170);
			
            addDisplay(World.REALITY, new parent_reality());
            addRadialAdditiveMask(World.REALITY, 150);
            addRadialSubtractiveMask(World.IMAGINATION, 275);
        }
        
    }

}