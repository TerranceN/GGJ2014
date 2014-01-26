package ata 
{
    import flash.display.DisplayObject;
    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.events.Event;
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	/**
     * ...
     * @author Ryan
     */
    public class World extends Sprite 
    {
        
        public static const REALITY:String = "REALITY";
        public static const IMAGINATION:String = "IMAGINATION";

        public var maskBitmap = null;
        public var inverseMaskBitmap = null;

        private var maskData:BitmapData = null
        private var inverseMaskData:BitmapData = null

        private var additiveBubbles:Array = new Array()
        private var subtractiveBubbles:Array = new Array();

        [Embed(source="../../assets/mask.png")]
		private var Mask:Class;
        private var maskInstance

        private var oldBitmap:Bitmap = null
        private var oldBitmapInverse:Bitmap = null

        public function World() 
        {
            maskData = new BitmapData(GameLogic.instance.w, GameLogic.instance.h, true, 0x00FFFFFF);
            inverseMaskData = new BitmapData(GameLogic.instance.w, GameLogic.instance.h, true, 0xFF000000)

            maskBitmap = new Bitmap(maskData)
            maskBitmap.cacheAsBitmap = true

            inverseMaskBitmap = new Bitmap(inverseMaskData)
            inverseMaskBitmap.cacheAsBitmap = true

            maskInstance = new Mask();
            this.cacheAsBitmap = true
        }

        public function addAdditiveBubble(entity:Entity, scale:Number=NaN):EffectBubble {
            var bubble:EffectBubble
            if (isNaN(scale)) {
                bubble = new EffectBubble(entity)
            } else {
                bubble = new EffectBubble(entity, scale)
            }
            additiveBubbles.push(bubble)
            //entity.addInfluence(World.IMAGINATION, maskInstance.width / 2)
            return bubble
        }

        public function addSubtractiveBubble(entity:Entity, scale:Number=NaN):EffectBubble {
            var bubble:EffectBubble
            if (isNaN(scale)) {
                bubble = new EffectBubble(entity)
            } else {
                bubble = new EffectBubble(entity, scale)
            }
            subtractiveBubbles.push(bubble)
            entity.addInfluence(World.REALITY, bubble.scale)
            return bubble
        }
        
        public function generateMasks():void {
            maskData.fillRect(maskData.rect, 0x00FFFFFF);

            for each (var bubble:EffectBubble in additiveBubbles) {
                var matrix:Matrix = new Matrix()
                var scale = bubble.scale * 2 / maskInstance.width
                matrix.scale(scale, scale)
                matrix.translate(
                    bubble.entity.position.x - GameLogic.camera.x - maskInstance.width * scale / 2,
                    bubble.entity.position.y - GameLogic.camera.y - maskInstance.height * scale / 2 - bubble.entity.size.y * 3 / 4
                )

                maskData.draw(maskInstance, matrix, null, null, null, false)
            }

            for each (var bubble:EffectBubble in subtractiveBubbles) {
                var matrix:Matrix = new Matrix()
                var scale = bubble.scale * 2 / maskInstance.width
                matrix.scale(scale, scale)
                matrix.translate(
                    bubble.entity.position.x - GameLogic.camera.x - maskInstance.width * scale / 2,
                    bubble.entity.position.y - GameLogic.camera.y - maskInstance.height * scale / 2 - bubble.entity.size.y * 3 / 4
                )

                maskData.draw(maskInstance, matrix, null, BlendMode.ERASE, null, false)
            }

            maskBitmap.x = GameLogic.camera.x
            maskBitmap.y = GameLogic.camera.y

            inverseMaskData.fillRect(inverseMaskData.rect, 0xFF000000)

            inverseMaskData.draw(maskBitmap, null, null, BlendMode.ERASE, null, false)

            inverseMaskBitmap.x = GameLogic.camera.x
            inverseMaskBitmap.y = GameLogic.camera.y
        }

        public function generateInverseMask() {
            if (oldBitmapInverse != null && oldBitmapInverse.parent != null) {
                oldBitmapInverse.parent.removeChild(oldBitmapInverse)
            }

            if (maskData == null) {
                maskData = new BitmapData(GameLogic.instance.w, GameLogic.instance.h, true, 0x00FFFFFF);
            } else {
                maskData.fillRect(maskData.rect, 0);
            }


            var bitmap = new Bitmap(maskData)
            oldBitmapInverse = bitmap
            bitmap.cacheAsBitmap = true
            return bitmap
        }
    }

}
