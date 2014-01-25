package ata
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * ...
	 * @author Matthew Hyndman
	 */
	[Frame(factoryClass="ata.Preloader")]
	public class Main extends Sprite 
	{
		private var input:Input;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			var levelHitbox:DisplayObject = new Level1RealityHitbox()
			levelHitbox.y = 400;
			addChild(levelHitbox)
			
			var level:DisplayObject = new Level1Reality()
			level.y = 500;
			addChild(level)
			
			
			var player:Player;
			player = new Player(100, 100);
			addChild(player);			
			input = new Input(stage);
			addChild(new GameLogic(stage.stageWidth, stage.stageHeight, input));
		}
		
	}
}