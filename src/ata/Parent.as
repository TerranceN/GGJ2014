package ata 
{
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
	/**
     * ...
     * @author Ryan
     */
    public class Parent extends Entity 
    {
        private static const IDLE_FRAME:uint = 1;
        private static const WALK_FRAME:uint = 2;
        private var parentR:MovieClip;
        private static const IMG_SCALE:Number = 0.9;
        
        public var bubble:EffectBubble = null;
        public function Parent() 
        {
            super(0, 130);
			
            parentR = new ParentReal();
            addDisplay(World.REALITY, parentR);
            parentR.gotoAndStop(IDLE_FRAME); 

            bubble = GameLogic.worldMap[World.IMAGINATION].addSubtractiveBubble(this, 68);
        }
        
        override public function update(input:Input, dt:Number, level:Level):void {
            super.update(input, dt, level);
            if (Math.abs(speed.x) < 50) {
                parentR.gotoAndStop(IDLE_FRAME);               
            } else {
                parentR.gotoAndStop(WALK_FRAME);               
            }
            
            if (speed.x < 0) {
                parentR.scaleX = -IMG_SCALE;
            } else if (speed.x > 0) {
                parentR.scaleX = IMG_SCALE;
            }
        }
    }

}
