package ata 
{
    import ata.levels.*;
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
    import flash.display.Shape;
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
        
        // for FPS indicator        
		private var framecount:uint = 0;
		private var interval:Number = 0;
        //
        
        public static var ground:int = 400;
        public var w:int;
        public var h:int;
        public var input:Input;

        public var player:Player;

        private var level:Level;
        public var levelNum:int;
        private var levelList:Vector.<Level>;
        
        private var entities:Vector.<Entity> = new Vector.<Entity>();
        public var stars:Vector.<Star> = new Vector.<Star>();
        public var effects:Vector.<Effect> = new Vector.<Effect>()
        public var carryableObjects:Vector.<CarryableObject> = new Vector.<CarryableObject>()
        
        public static var worldMap:Object = {};

        public static var numStars:int = 0;
        private var cameraOffset:Vector2 = new Vector2(400, 350);
        private var cameraVelocity:Vector2 = new Vector2(0, 0);
        public static var camera:Vector2 = new Vector2(0, 0);
        
        public static var instance:GameLogic;

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

            levelList = new Vector.<Level>();
            levelList.push(new Level1());
            levelList.push(new Level2());
            setLevel(0);
        }
        
        public function clearEntities():void {
            for each (var world:World in worldMap) {
                while (world.numChildren > 0) {
                    world.removeChildAt(0);
                }
                world.clearBubbles()
            }
            entities = new Vector.<Entity>();
            stars = new Vector.<Star>();
            effects = new Vector.<Effect>();
        }
        
        public function setLevel(n:uint):void {
            if (n < 0 || n >= levelList.length) return;
            
            clearEntities();
            
            levelNum = n;
            level = levelList[n];
            
            addEntity(level);
            
            level.setupLevel(this);
            
            //addEntity(new Bird(w / 3, - h / 4));
            
            player = new Player(75, 0);
            addEntity(player);
            
            // only do this on some levels
            
            var testObj:CarryableObject = new CarryableObject(player.position.add(new Vector2(500, 0)), new RSword(), new ISword());
            carryableObjects.push(testObj);
        }

        public function update(dt:Number):void {
            var t:uint = getTimer();
            dt =  Math.min(0.1, (t - totaltime) / 1000);
            totaltime = t;

            if (Main.showFPS) {
                interval += dt;
                framecount++;
                if (interval > 0.5) {
                    var framerate:int = int(framecount / interval);//1 / dt;
                    Main.FPS.setText("FPS: " + framerate);
                    interval -= 0.5;
                    framecount = 0;
                }
            }
            
            if (!Paused)
            {
                overtime = overtime + dt;
                while (overtime > T) //as soon as reach last frame, game is done. stop updating.
                {
                    overtime = overtime - T;
                    fixedupdate(T);
                    if (input.justpressed(Keyboard.Q) || input.justpressed(Keyboard.ESCAPE)) {
                        fscommand("quit");
                    } else if (input.justpressed(Keyboard.R)) {
                        // Reset scene to initial state
                    }
                    input.update(T); // note: this will change justpressed to false for all keys, input dependant logic should happen before this
                }
                draw();
            }

            for each(var obj:CarryableObject in carryableObjects) {
                var objectToPickUp:Boolean = false

                if (obj.onGround && obj.position.add(player.position.times(-1)).length() < 50) {
                    objectToPickUp = true
                    Main.pickUpPrompt.x = player.x - camera.x - Main.pickUpPrompt.width + Main.pickUpPrompt.textWidth / 2
                    Main.pickUpPrompt.y = player.y - camera.y + 20
                    Main.pickUpPrompt.visible = true
                    // objects are close enough, prompt player

                    // if player presses v, pick up the object
                    if (input.isdown(Keyboard.V)) {
                        trace("qwerty")
                        obj.setPickedUp()
                        player.swordImag.visible = true;
                        player.swordReal.visible = true;
                    }
                }

                if (!objectToPickUp) {
                    Main.pickUpPrompt.visible = false
                }
            }
            
            for each(var effect:Effect in effects)
            {
                effect.timeLeft --;
                if (effect.timeLeft <= 0)
                {
                    removeEntity(effect);
                    effects.splice(effects.indexOf(effect), 1);
                }
            }
        }

        private function updateCamera(dt:Number):void
        {
            camera.x += cameraVelocity.x * dt;
            camera.y += cameraVelocity.y * dt;
            camera.x = Math.max(level.x1, Math.min(camera.x,level.x2-this.w-50));

            var cameraVelocityDelta:Vector2 = new Vector2(0,0);
            var nextCameraVelocityDelta:Vector2 = new Vector2(0,0);
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

            if (Math.abs(cameraVelocityDelta.x) < 100) {
                cameraVelocity.x = 0
                cameraVelocityDelta.x = 0
            }

            if (Math.abs(cameraVelocityDelta.y) < 100) {
                cameraVelocity.y = 0
                cameraVelocityDelta.y = 0
            }

            this.x = -camera.x
            this.y = -camera.y

            for each (var worldString:String in World.TYPES)
            {
                worldMap[worldString].background.x = camera.x;
                worldMap[worldString].background.y = camera.y;
            }
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
                if(entity.influencedBy[World.FORCE_REAL])
                {
                    entity.influencedBy[World.REALITY] = true;
                }
                else
                {
                    entity.influencedBy[World.REALITY] = false;
                }
                entity.influencedBy[World.IMAGINATION] = false;
                    
                for each (var otherEntity:Entity in entities)
                {
                    if (entity != otherEntity)
                    {
                        for (worldString in otherEntity.influences)
                        {
                            if (entity.position.diff(otherEntity.position)-entity.size.length() < otherEntity.influences[worldString])
                            {
                                entity.influencedBy[worldString] = true;
                            }
                        }
                    }
                }
            }
            
            if (player.influencedBy[World.REALITY] || player.influencedBy[World.FORCE_REAL])
            {
                player.bubble.scaleModifier -= player.bubble.scaleModifier / 5
            }
            else if(!player.influencedBy[World.REALITY])
            {
                for each(var starEntity:Star in stars)
                {
                    if (player.position.diff(starEntity.position) < (player.size.length() + starEntity.size.length())/4)
                    {
                        removeEntity(starEntity);
                        stars.splice(stars.indexOf(starEntity), 1);
                        numStars++;
                        Main.Score.setText("Stars: " + numStars + "/" + Main.TOTAL_STARS);
                        
                        var explode:Effect = new Effect(new explosion(), new explosion(), 16);
                        explode.position.x = starEntity.position.x;
                        explode.position.y = starEntity.position.y;
                        effects.push(explode);
                        addEntity(explode);
                    }
                }
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
        
        public function addEntity(e:Entity):void
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
        
        public function removeEntity(e:Entity):void
        {
            var world:World;
            var worldString:String;
            var displayObjects:Vector.<DisplayObject>;
            var displayObject:DisplayObject;
            entities.splice(entities.indexOf(e),1);
            for (worldString in e.displayObjects)
            {
                makeWorldIfNotExists(worldString);
                world = worldMap[worldString];
                displayObjects = e.displayObjects[worldString];
                for each (displayObject in displayObjects)
                {
                    world.removeChild(displayObject);
                }
            }
            
            /*for (worldString in e.additiveMasks)
            {
                makeWorldIfNotExists(worldString);
                world = worldMap[worldString];
                displayObjects = e.additiveMasks[worldString];
                for each (displayObject in displayObjects)
                {
                    world.additiveMask.removeChild(displayObject);
                }
            }
            
            for (worldString in e.subtractiveMasks)
            {
                makeWorldIfNotExists(worldString);
                world = worldMap[worldString];
                displayObjects = e.subtractiveMasks[worldString];
                for each (displayObject in displayObjects)
                {
                    world.subtractiveMask.removeChild(displayObject);
                }
            }*/
        }

        public function stoplistening():void
        {
            this.removeEventListener(Event.ENTER_FRAME, update);
        }
    }
}
