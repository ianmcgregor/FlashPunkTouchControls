package org.alwaysinbeta.games.ui.graphics {
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Key;

	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author McFamily
	 */
	public class KeyGraphic extends Image {
		public function KeyGraphic(keyCode : uint, color : uint) {
			super(drawImage(keyCode, color), null);
		}

		private function drawImage(keyCode : uint, color : uint) : BitmapData {
			var radius : int = 40;
			var shape : Sprite = new Sprite();
			var g : Graphics = shape.graphics;
			g.beginFill(color);
			g.drawCircle(radius, radius, radius);
			g.endFill();

			var text : TextField = new TextField();
			text.defaultTextFormat = new TextFormat(Text.font, 72);
			text.text = Key.name(keyCode);
			text.embedFonts = true;
			text.autoSize = TextFieldAutoSize.LEFT;
			text.x = 2 + (shape.width - text.textWidth) * 0.5;
			text.y = 2 + (shape.height - text.textHeight) * 0.5;
			shape.addChild(text);

			var bitmapData : BitmapData = new BitmapData(radius * 2, radius * 2, true, 0x00FFFFFF);
			bitmapData.draw(shape, null, null, null, null, true);

			return bitmapData;
		}
	}
}
