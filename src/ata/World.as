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
            display = new Sprite();
            addChild(display);
            additiveMask = new Sprite();
            addChild(additiveMask);
            subtractiveMask = new Sprite();
            addChild(subtractiveMask);
            
            this.blendMode = BlendMode.LAYER;
            display.mask = additiveMask;
            subtractiveMask.blendMode = BlendMode.ALPHA;
        }
        
    }

}