package ata
{
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * ...
	 * @author Matthew Hyndman
	 */
	[Frame(factoryClass="ata.Preloader")]
	public class Main extends Sprite 
	{

		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			var player:Player;
			player = new Player(100, 100);
			addChild(player);			
		}

	}

}