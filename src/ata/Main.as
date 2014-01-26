package ata
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;

	/**
	 * ...
	 * @author Matthew Hyndman
	 */
	[Frame(factoryClass="ata.Preloader")]
	public class Main extends Sprite 
	{
		private var input:Input;
		public static var FPS:DisplayText;
        public static var showFPS:Boolean;

		public static var pickUpPrompt:DisplayText;
        
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			input = new Input(stage);
			addChild(new GameLogic(stage.stageWidth, stage.stageHeight, input));
            
            FPS = new DisplayText(250, 10, "FPS:", 12, 0, "LEFT", DisplayText.DefaultFont,0x303030);
            stage.addChild(FPS);

            pickUpPrompt = new DisplayText(250, 10, "Press V to pick this item up", 12, 0, "LEFT", DisplayText.DefaultFont,0x303030);
            stage.addChild(pickUpPrompt)
            pickUpPrompt.visible = false;

            showFPS = true;
		}
		
	}
}
