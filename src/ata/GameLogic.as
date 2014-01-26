package ata 
{
    import flash.display.BlendMode;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.system.fscommand;
    import flash.ui.Keyboard;
    import flash.utils.getTimer;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
    /**
     * ...
     * @author Matthew Hyndman
     */

    public class GameLogic extends Sprite
    {
        //[Embed(source = "../../../assets/tilemap/tilemap.png")]
        //private var Tiles:Class;

        public var Paused:Boolean = false;
        public var dt:Number;
        public var totaltime:Number = 0;

        public var overtime:Number = 0;
        public static var T:Number = 0.033; // time between fixed update frames
        public static var ground:int = 400;
        public var w:int;
        public var h:int;
        public var input:Input;

        private var player:Player;

        private var level:Level;
        
        private var entities:Vector.<Entity> = new Vector.<Entity>();
        
        public static var worldMap:Object = {};

        private var cameraOffset:Point = new Point(400, 300);
        private var cameraVelocity:Point = new Point(0, 0);
        public static var camera:Point = new Point(0, 0);

        public static var instance:GameLogic

        public function GameLogic(w:int, h:int, input:Input) 
        {
            instance = this

            this.w = w;
            this.h = h;
            this.input = input;

            addEventListener(Event.ENTER_FRAME, update);
            
            var imgWorld:World = new World();
            worldMap[World.IMAGINATION] = imgWorld;
            addChild(imgWorld);
            
            var realWorld:World = new World();
            worldMap[World.REALITY] = realWorld;
            addChild(realWorld);

            worldMap[World.REALITY].mask = worldMap[World.IMAGINATION].inverseMaskBitmap
            addChild(worldMap[World.IMAGINATION].inverseMaskBitmap)
            
            level = new Level(new level1_reality(), new level1_reality_hitbox(), new level1_reality_platforms(), new level_1_imagination());
            addEntity(level);
            
            addEntity(new Bird(w / 3, h / 4));
            
            player = new Player(w/2, 0);
            addEntity(player);
            
            var parent:Parent = new Parent();
            parent.position.x = 800;
            addEntity(parent);
            parent = new Parent();
            parent.position.x = 1000;
            addEntity(parent);
            parent = new Parent();
            parent.position.x = 1200;
            addEntity(parent);
        }

        public function update(dt:Number):void {
            var t:uint = getTimer();
            dt =  Math.min(0.1, (t - totaltime) / 1000);
            totaltime = t;

            if (!Paused)
            {
                overtime = overtime + dt;
                while (overtime > T) //as soon as reach last frame, game is done. stop updating.
                {
                    overtime = overtime - T;
                    fixedupdate(T);
                    input.update(T);
                    if (input.justpressed(Keyboard.Q) || input.justpressed(Keyboard.ESCAPE)) {
                        fscommand("quit");
                    } else if (input.justpressed(Keyboard.R)) {
                        // Reset scene to initial state
                    }
                }
                draw();
            }
        }

        private function updateCamera(dt:Number):void
        {
            camera.x += cameraVelocity.x * dt;
            camera.y += cameraVelocity.y * dt;
            camera.x = Math.max(level.x1, Math.min(camera.x,level.x2));

            var cameraVelocityDelta:Point = new Point(0,0);
            var nextCameraVelocityDelta:Point = new Point(0,0);
            cameraVelocityDelta.x = (player.position.x - cameraOffset.x - camera.x) * 4;
            cameraVelocityDelta.y = (player.position.y - cameraOffset.y - camera.y) * 4;

            if (cameraVelocityDelta.x * cameraVelocity.x < 0)
            {
                cameraVelocity.x = 0;
            }
            else
            {
                cameraVelocity.x += cameraVelocityDelta.x;
                cameraVelocity.x *= 0.5;
            }

            if (cameraVelocityDelta.y * cameraVelocity.y < 0)
            {
                cameraVelocity.y = 0;
            }
            else
            {
                cameraVelocity.y += cameraVelocityDelta.y;
                cameraVelocity.y *= 0.5;
            }

            this.x = -camera.x
            this.y = -camera.y
        }

        private function draw():void {
            var bitmap:Bitmap = worldMap[World.IMAGINATION].generateMasks()
        }

        public function fixedupdate(dt:Number):void //dt is 1/50th of a second
        {
            for each (var entity:Entity in entities)
            {
                entity.update(input, dt, level);
                
                var worldString:String;
                for (worldString in entity.influencedBy)
                {
                    entity.influencedBy[worldString] = false;
                }
                
                for each (var otherEntity:Entity in entities)
                {
                    if (entity != otherEntity)
                    {
                        for (worldString in otherEntity.influences)
                        {
                            if (entity.position.diff(otherEntity.position) < otherEntity.influences[worldString])
                            {
                                entity.influencedBy[worldString] = true;
                            }
                        }
                    }
                }
            }
            if (player.influencedBy[World.REALITY])
            {
                player.bubble.scaleModifier -= player.bubble.scaleModifier / 5
            }
            else
            {
                player.bubble.scaleModifier += (1 - player.bubble.scaleModifier) / 5
            }
            updateCamera(dt);
        }
        
        private function makeWorldIfNotExists(worldString:String):void
        {
            if (worldMap[worldString] == undefined)
            {
                var world:World = new World();
                addChildAt(world, 0);
                worldMap[worldString] = world;
            }
        }
        
        private function addEntity(e:Entity):void
        {
            var world:World;
            var worldString:String;
            var displayObjects:Vector.<DisplayObject>;
            var displayObject:DisplayObject;
            entities.push(e);
            for (worldString in e.displayObjects)
            {
                makeWorldIfNotExists(worldString);
                world = worldMap[worldString];
                displayObjects = e.displayObjects[worldString];
                for each (displayObject in displayObjects)
                {
                    world.addChild(displayObject);
                }
            }
        }

        public function stoplistening():void
        {
            this.removeEventListener(Event.ENTER_FRAME, update);
        }
    }
}
