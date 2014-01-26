package ata
{
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author Matthew Hyndman
	 */
	public class DisplayText extends TextField 
	{
		public static var DefaultFont:String = "Century Gothic";
		
		[Embed(source = '../../assets/Gothic.ttf',
				fontName = "Century Gothic",
				mimeType = "application/x-font-truetype",
				embedAsCFF = "false")]
		private var Font0:Class;
        
		public function DisplayText(posx:Number, posy:Number, defaulttext:String, size:Number=16,linewidth:Number = 0,align:String = "LEFT",font:String="Century Gothic",color:uint=0x000000,multiline:Boolean = true):void//basically just a bunch of predefined settings.
		{
			super();
			mouseEnabled = false;
			this.x = posx;
			this.y = posy-3;
			
			if (font == "Century Gothic")
				y = posy - 2;
			if (size < 20) {
				antiAliasType = AntiAliasType.ADVANCED;
				//this.sharpness = 100;
				//this.thickness = 25;
				gridFitType = GridFitType.PIXEL;
			}
			var tf:TextFormat = new TextFormat(font, size, color);
			
			if (linewidth == 0) {
				switch (align)
				{
				case "CENTER": autoSize = TextFieldAutoSize.CENTER; break;
				case "RIGHT": autoSize = TextFieldAutoSize.RIGHT; break;
				default: autoSize = TextFieldAutoSize.LEFT; break;
				this.height = size * 1.4;
				}
			} else {
				switch (align)
				{
				case "CENTER": tf.align = TextFormatAlign.CENTER; break;
				case "RIGHT": tf.align = TextFormatAlign.RIGHT; break;
				default: tf.align = TextFormatAlign.LEFT;
				}
				this.width = linewidth;// == 0 ? Main.windowwidth : linewidth;
				this.wordWrap = multiline;
			}
			//this.width = x2 - x1;
			this.text = defaulttext;
			this.type = TextFieldType.DYNAMIC;
			this.selectable = false;
			this.setTextFormat(tf);
			
			if (linewidth != 0)
				this.height = this.textHeight + 4;
			
			//trace(font, antiAliasType,sharpness,thickness,this.getLineMetrics(0));
			
			this.filters = [new DropShadowFilter(2, 45, 0x000000, 0.7, 4, 4)];
		}
		
		public function setText(s:String):void {
			//this is reused code to prevent loss of textformat I think
			replaceText(0, text.length-1, s);
			replaceText(text.length-1,text.length,"");
		}
	}
	
}