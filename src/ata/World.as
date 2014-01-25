package ata 
{
    import flash.display.DisplayObject;
    import flash.display.BlendMode;
    import flash.display.Sprite;
	/**
     * ...
     * @author Ryan
     */
    public class World extends Sprite 
    {
        
        public static const REALITY:String = "REALITY";
        public static const IMAGINATION:String = "IMAGINATION";
        
        public var display:Sprite;
        public var additiveMask:Sprite;
        public var subtractiveMask:Sprite;
        
        public function World() 
        {
            subtractiveMask = new Sprite();
            addChild(subtractiveMask);
            display = new Sprite();
            subtractiveMask.addChild(display);
            additiveMask = new Sprite();
            //subtractiveMask.addChild(additiveMask);
            
            //this.blendMode = BlendMode.LAYER;
            //display.mask = additiveMask;
            subtractiveMask.blendMode = BlendMode.LAYER;
        }
        
    }

}