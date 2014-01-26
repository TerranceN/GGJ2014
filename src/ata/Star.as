package ata 
{
	/**
     * ...
     * @author Ryan
     */
    public class Star extends Entity 
    {
        
        public function Star() 
        {
            super(170, 170);
			addDisplay(World.IMAGINATION, new star());
        }
        
    }

}