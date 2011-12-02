package org.alwaysinbeta.games.ui {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;

	import org.alwaysinbeta.games.ui.graphics.KeyGraphic;

	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.system.Capabilities;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	/**
	 * @author McFamily
	 */
	public class TouchKey extends Entity {
		private var _keyCode : uint;
		private var _touchPointID : int;

		public function TouchKey(x : Number = 0, y : Number = 0, keyCode : uint = 0, color : uint = 0xFF0000) {
			_keyCode = keyCode;
			var image : Image = new KeyGraphic(keyCode, color);
			graphic = image;
			setHitbox(image.width, image.height);

			this.x = x;
			this.y = y;
		}

		override public function added() : void {
			// FP.console.log("cpuArchitecture:"+Capabilities.cpuArchitecture);

			if (Capabilities.cpuArchitecture == "ARM") {
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				FP.stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
				FP.stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
				// FP.stage.addEventListener(TouchEvent.TOUCH_TAP, onTouchTap);
			} else {
				FP.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				FP.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
		}

		private function onTouchBegin(event : TouchEvent) : void {
			if (collidePoint(this.x, this.y, event.stageX, event.stageY)) {
				_touchPointID = event.touchPointID;
				FP.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, false, 0, _keyCode));
			}
		}

		private function onTouchEnd(event : TouchEvent) : void {
			if (event.touchPointID == _touchPointID ) {
				FP.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, false, 0, _keyCode));
			}
		}

		// for testing
		private function onMouseDown(event : MouseEvent) : void {
			if (collidePoint(this.x, this.y, event.stageX, event.stageY)) {
				FP.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, false, 0, _keyCode));
			}
		}

		private function onMouseUp(event : MouseEvent) : void {
			// if (collidePoint(this.x, this.y, event.stageX, event.stageY)) {
			FP.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, false, 0, _keyCode));
			// }
		}
	}
}
