package ata {
	import flash.display.Sprite;

    public class CarryableObject {
        public var position:Vector2
        public var item:Sprite
        public var onGround:Boolean = true

        public function CarryableObject(initPosition:Vector2, renderableObject:Sprite) {
            position = initPosition
            item = renderableObject
            item.x = position.x
            item.y = position.y

            setPlacedDown()
        }

        public function setPickedUp() {
            // remove from game world

            GameLogic.worldMap[World.REALITY].removeChild(item)

            onGround = false

            trace("asdf")
        }

        public function setPlacedDown() {
            // add to game world
            GameLogic.worldMap[World.REALITY].addChild(item)

            onGround = true
        }
    }
}
