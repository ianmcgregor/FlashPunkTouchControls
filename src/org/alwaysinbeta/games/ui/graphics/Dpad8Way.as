package org.alwaysinbeta.games.ui.graphics{
	import net.flashpunk.graphics.Image;

	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;

	/**
	 * @author McFamily
	 */
	public class Dpad8Way extends Image {
		public function Dpad8Way(radius: int = 40, centerRadius: int = 10) {
			super(drawImage(radius, centerRadius));
		}

		private function drawImage(radius: int, centerRadius: int = 0) : BitmapData {
//			var radius : int = 40;
			var shape : Shape = new Shape();
			var g : Graphics = shape.graphics;

			var angle : Number = -22.5;
			var arc : Number = 45;
			var labels : Array = ["R", "DR", "D", "DL", "L", "UL", "U", "UR"];
			var colors : Array = [0x555555, 0x888888];
			var color : int = 0;

			for (var i : int = 0; i < labels.length; i++) {
				g.beginFill(colors[color]);
				color++;
				if (color == colors.length) {
					color = 0;
				}
				if (angle > 180) angle = angle - 360;
				drawSegment(g, radius, radius, radius, angle, angle + arc);
				trace(labels[i], ': degrees:', angle, 'rads:', radians(angle));
				angle += arc;
			}

			if(centerRadius > 0){
				g.beginFill(0x000000, 1);
				g.drawCircle(radius, radius, centerRadius);
//				g.endFill();
			}

			g.endFill();

			var bitmapData : BitmapData = new BitmapData(radius * 2, radius * 2, true, 0x00FFFFFF);
			bitmapData.draw(shape, null, null, null, null, true);
			return bitmapData;
		}
		
		private function radians(degrees:Number):Number{
		    return degrees * Math.PI / 180;
		}
		
		private function drawSegment(graphics : Graphics, x:Number, y:Number, r:Number, aStart:Number, aEnd:Number, step:Number = 1):void {
                // More efficient to work in radians
                var degreesPerRadian:Number = Math.PI / 180;
                aStart *= degreesPerRadian;
                aEnd *= degreesPerRadian;
                step *= degreesPerRadian;
 
                // Draw the segment
                graphics.moveTo(x, y);
                for (var theta:Number = aStart; theta < aEnd; theta += Math.min(step, aEnd - theta)) {
                    graphics.lineTo(x + r * Math.cos(theta), y + r * Math.sin(theta));
                }
                graphics.lineTo(x + r * Math.cos(aEnd), y + r * Math.sin(aEnd));
                graphics.lineTo(x, y);
        }
	}
}
