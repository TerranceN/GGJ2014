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
            super(67, 170);
			
            addDisplay(World.REALITY, new parent_reality());
            addRadialAdditiveMask(World.REALITY, 300);
            //addRadialSubtractiveMask(World.IMAGINATION, 300);
        }
        
    }

}