package ata {

    public class EffectBubble {
        public var entity:Entity
        private var _scale:Number
        public var scaleModifier:Number = 1

        public function EffectBubble(newEntity:Entity, newScale:Number = 300) {
            entity = newEntity
            _scale = newScale
        }

        public function get scale():Number {
            return _scale * scaleModifier
        }
    }
}
