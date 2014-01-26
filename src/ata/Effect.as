package ata 
{
    import flash.display.DisplayObject;
	/**
     * ...
     * @author Ryan
     */
    public class Effect extends Entity 
    {
        public var timeLeft:int;
        public function Effect(d:DisplayObject, time:int) 
        {
            super(d.width, d.height);
			addDisplay(World.REALITY, d);
			addDisplay(World.IMAGINATION, d);
            timeLeft = time;
        }
        
    }

}