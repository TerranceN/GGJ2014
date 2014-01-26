package ata {
    import flash.display.MovieClip;
	import flash.display.Sprite;

    public class CarryableObject {
        public var position:Vector2
        public var item1:MovieClip
        public var item2:MovieClip
        public var onGround:Boolean = true
        private static const ON_GROUND:uint = 4;

        public function CarryableObject(initPosition:Vector2, realObj:MovieClip, imagObj:MovieClip) {
            position = initPosition
            item1 = realObj;
            item2 = imagObj;
            item1.x = item2.x = position.x
            item1.y = item2.y = position.y
            
            item1.gotoAndStop(ON_GROUND);
            item2.gotoAndStop(ON_GROUND);

            setPlacedDown()
        }

        public function setPickedUp():void {
            // remove from game world

            GameLogic.worldMap[World.REALITY].removeChild(item1)
            GameLogic.worldMap[World.IMAGINATION].removeChild(item2)

            onGround = false
        }

        public function setPlacedDown():void {
            // add to game world
            GameLogic.worldMap[World.REALITY].addChild(item1)
            GameLogic.worldMap[World.IMAGINATION].addChild(item2)

            onGround = true
        }
    }
}
