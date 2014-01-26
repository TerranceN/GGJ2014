package ata 
{
    import flash.display.DisplayObject;
    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.events.Event;
	/**
     * ...
     * @author Ryan
     */
    public class World extends Sprite 
    {
        
        public static const REALITY:String = "REALITY";
        public static const IMAGINATION:String = "IMAGINATION";
        
        public static const grow_factor:Number = 0.2;
        
        public var display:Sprite;
        public var additiveMask:Sprite;
        public var subtractiveMask:Sprite;
        
        public var targetAdditiveScale:Number = 1;
        public var currentAdditiveScale:Number = 1;
        public var targetSubtractiveScale:Number = 1;
        public var currentSubtractiveScale:Number = 1;
        public var targetAlpha:Number = 1;
        
        public function World() 
        {
            display = new Sprite();
            //display.cacheAsBitmap = true;
            addChild(display);
            additiveMask = new Sprite();
            //additiveMask.cacheAsBitmap = true;
            addChild(additiveMask);
            subtractiveMask = new Sprite();
            //subtractiveMask.cacheAsBitmap = true;
            addChild(subtractiveMask);
            
            this.blendMode = BlendMode.LAYER;
            display.mask = additiveMask;
            subtractiveMask.blendMode = BlendMode.ALPHA;
            
            addEventListener(Event.ENTER_FRAME, doScale);
        }
        
        public function scaleAdditiveInfluence(scale:Number):void
        {
            targetAdditiveScale = scale;
        }
        
        public function scaleSubtractiveInfluence(scale:Number):void
        {
            targetSubtractiveScale = scale;
        }
        
        public function fadeTo(alpha:Number):void
        {
            targetAlpha = alpha;
        }
        
        public function doScale(e:Event):void
        {
            if (targetAdditiveScale > currentAdditiveScale)
            {
                currentAdditiveScale += grow_factor;
            }
            if (targetAdditiveScale < currentAdditiveScale)
            {
                currentAdditiveScale -= grow_factor;
            }
            
            if (Math.abs(currentAdditiveScale-targetAdditiveScale) <= grow_factor)
            {
                currentAdditiveScale = targetAdditiveScale;
            }
            
            if (targetSubtractiveScale > currentSubtractiveScale)
            {
                currentSubtractiveScale += grow_factor;
            }
            if (targetSubtractiveScale < currentSubtractiveScale)
            {
                currentSubtractiveScale -= grow_factor;
            }
            
            if (Math.abs(currentSubtractiveScale-targetSubtractiveScale) <= grow_factor)
            {
                currentSubtractiveScale = targetSubtractiveScale;
            }
            
            for (var i:uint=0; i<additiveMask.numChildren; i++){
                additiveMask.getChildAt(i).scaleX = currentAdditiveScale;
                additiveMask.getChildAt(i).scaleY = currentAdditiveScale;
            }
            
            for (i=0; i<subtractiveMask.numChildren; i++){
                subtractiveMask.getChildAt(i).scaleX = currentSubtractiveScale;
                subtractiveMask.getChildAt(i).scaleY = currentSubtractiveScale;
            }
            
            if (targetAlpha > display.alpha)
            {
                display.alpha += 0.03;
            }
            if (targetAlpha < display.alpha)
            {
                display.alpha -= 0.03;
            }
            
            if (Math.abs(display.alpha-targetAlpha) <= 0.03)
            {
                display.alpha = targetAlpha;
            }
        }
        
        public function applyMask():void
        {
            if (display.mask == null)
            {
                display.mask = additiveMask;
            }
        }
        
        public function removeMask():void
        {
            if (display.mask != null)
            {
                display.mask = null;
            }
        }
        
    }

}