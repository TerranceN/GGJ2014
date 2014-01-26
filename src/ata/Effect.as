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
        public function Effect(real:DisplayObject, imag:DisplayObject, time:int) 
        {
            super(real.width, real.height);
            if (real)
            {
			    addDisplay(World.REALITY, real);
            }
            if (imag)
            {
			    addDisplay(World.IMAGINATION, imag);
            }
            timeLeft = time;
        }
        
    }

}