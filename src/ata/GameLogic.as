package ata 
{
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.utils.getTimer;
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
        private var w:int;
        private var h:int;
        public var input:Input;

        private var player:Player;

        private var level:Level;
        
        private var entities:Vector.<Entity> = new Vector.<Entity>();
        
        private var worldMap:Object = {};
        

        private var cameraOffset:Point = new Point(400, 300);
        private var cameraVelocity:Point = new Point(0, 0);
        public static var camera:Point = new Point(0, 0);

        public function GameLogic(w:int, h:int, input:Input) 
        {
            this.w = w;
            this.h = h;
            this.input = input;

            addEventListener(Event.ENTER_FRAME, update);

            player = new Player(w/2, h/2);
            addEntity(player);

            level = new Level();
            addEntity(level);
            
            var realWorld:World = new World();
            worldMap[World.REALITY] = realWorld;
            addChild(realWorld);
            
            var imgWorld:World = new World();
            worldMap[World.IMAGINATION] = imgWorld;
            addChild(imgWorld);
        }

        public function update(dt:Number):void {
            var t:uint = getTimer();
            dt =  Math.min(0.1, (t - totaltime) / 1000);
            trace("FPS", 1000/(t - totaltime))
            totaltime = t;

            if (!Paused)
            {
                overtime = overtime + dt;
                while (overtime > T) //as soon as reach last frame, game is done. stop updating.
                {
                    overtime = overtime - T;
                    fixedupdate(T);
                    input.update(T);
                }
                updateHUD();
            }
        }

        private function updateCamera(dt:Number):void
        {
            camera.x += cameraVelocity.x * dt;
            camera.y += cameraVelocity.y * dt;

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

        private function updateHUD():void 
        {
        }

        public function fixedupdate(dt:Number):void //dt is 1/50th of a second
        {
            level.update(input, dt, level);
            player.update(input, dt, level);
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
            entities.push(e);
            for (worldString in e.displayObjects)
            {
                makeWorldIfNotExists(worldString);
                world = worldMap[worldString];
                world.display.addChild(e.displayObjects[worldString]);
            }
            
            for (worldString in e.additiveMasks)
            {
                makeWorldIfNotExists(worldString);
                world = worldMap[worldString];
                world.additiveMask.addChild(e.additiveMasks[worldString]);
            }
            
            for (worldString in e.subtractiveMasks)
            {
                makeWorldIfNotExists(worldString);
                world = worldMap[worldString];
                world.subtractiveMask.addChild(e.subtractiveMasks[worldString]);
            }
        }

        public function stoplistening():void
        {
            this.removeEventListener(Event.ENTER_FRAME, update);
        }
    }
}
