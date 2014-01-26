package ata.levels 
{
	import ata.Level;
	import flash.display.DisplayObject;
	
	/**
     * ...
     * @author Ryan
     */
    public class Level2 extends Level 
    {
        
        public function Level2() 
        {
            super(new playground_reality(), new playground_reality_hitbox(), new playground_reality_platforms(),
                    new playground_imagination(), new playground_reality_hitbox(), new playground_imagination_platforms());
			
        }
        
    }

}