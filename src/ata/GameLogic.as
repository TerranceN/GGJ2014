package ata 
{
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
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
        public static var T:Number = 0.02; // time between fixed update frames
        public static var ground:int = 400;
        private var w:int;
        private var h:int;
        public var input:Input;

        private var player:Player;

        private var level:Level;

        public function GameLogic(w:int, h:int, input:Input) 
        {
            this.w = w;
            this.h = h;
            this.input = input;

            addEventListener(Event.ENTER_FRAME, update);

            player = new Player(w/2, h/2);
            addChild(player);

            level = new Level(this);
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
                }
                updateHUD();
            }
        }

        private function updateHUD():void 
        {
        }

        public function fixedupdate(dt:Number):void //dt is 1/50th of a second
        {
            player.update(input, dt, level);
        }

        public function stoplistening():void
        {
            this.removeEventListener(Event.ENTER_FRAME, update);
        }
    }
}
