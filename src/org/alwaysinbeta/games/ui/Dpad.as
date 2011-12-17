package org.alwaysinbeta.games.ui {
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import org.alwaysinbeta.games.ui.graphics.Dpad4Way;
	import org.alwaysinbeta.games.ui.graphics.Dpad8Way;



	/**
	 * @author McFamily
	 */
	public class Dpad extends Entity {
		private var _touchPointID : int;
		private var _keyCodeA : uint;
		private var _keyCodeB : uint;
		private var _previousKeyCodeA : uint;
		private var _previousKeyCodeB : uint;
		private var _minDistance : Number = 20;
		private var _maxDistance : Number = 80;
		private var _centerX : Number;
		private var _centerY : Number;
		private var _keyUpEvent : KeyboardEvent;
		private var _keyDownEvent : KeyboardEvent;
		private var _is8Way : Boolean;
		// 8 way
		private const R : Number = -0.39269908169872414;
		private const DR : Number = 0.39269908169872414;
		private const D : Number = 1.1780972450961724;
		private const DL : Number = 1.9634954084936207;
		private const L : Number = 2.748893571891069;
		private const UL : Number = -2.748893571891069;
		private const U : Number = -1.9634954084936207;
		private const UR : Number = -1.1780972450961724;
		// 4 way
		private const RIGHT : Number = -0.7853981633974483;
		private const DOWN : Number = 0.7853981633974483;
		private const LEFT : Number = 2.356194490192345;
		private const UP : Number = -2.356194490192345;


		/*
		 * 
		 * 
		 */
		public function Dpad(x : Number, y : Number, is8Way : Boolean = true) {
			// super(x, y, graphic, mask);
			_is8Way = is8Way;

			//var image : Image = _is8Way ? new Dpad8Way(_maxDistance, _minDistance) : new Dpad4Way(_maxDistance, _minDistance);
			//graphic = image;
			//setHitbox(image.width, image.height);
			if(!graphic)graphic = _is8Way ? new Dpad8Way(_maxDistance, _minDistance) : new Dpad4Way(_maxDistance, _minDistance);
			this.graphic = graphic;
			setHitboxTo(graphic);
			
			graphic.scrollX = graphic.scrollY = 0;

			this.x = x;
			this.y = y;
			
			//_maxDistance = width;
			_centerX = x + width * 0.5;
			_centerY = y + height * 0.5;

			// super(x, y, graphic, mask);
		}

		override public function added() : void {
			// Multitouch.supportsTouchEvents
			
			_keyUpEvent = new KeyboardEvent(KeyboardEvent.KEY_UP, false, false, 0, 0);
			_keyDownEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, false, 0, 0);
			
			var supportsTouchEvents: Boolean = Capabilities.cpuArchitecture == "ARM";
			if (supportsTouchEvents) {
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				FP.stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
				FP.stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
			} else {
				FP.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				FP.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
		}

		private function onTouchBegin(event : TouchEvent) : void {
			if (collidePoint(this.x, this.y, event.stageX, event.stageY)) {
				_touchPointID = event.touchPointID;
				FP.stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			}
		}

		private function onTouchEnd(event : TouchEvent) : void {
			if (event.touchPointID != _touchPointID) return;

			if (_keyCodeA > 0) {
				dispatchKeyUp(_keyCodeA);
			}
			if (_keyCodeB > 0) {
				dispatchKeyUp(_keyCodeB);
			}
			FP.stage.removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			_keyCodeA = _keyCodeB = _touchPointID = 0;
		}

		private function onTouchMove(event : TouchEvent) : void {
			if (event.touchPointID != _touchPointID) return;

			calculateTouches(event.stageX, event.stageY);
		}

		private function calculateTouches(touchX : Number, touchY : Number) : void {
			var rads : Number = Math.atan2(touchY - this.y - height * 0.5, touchX - this.x - width * 0.5);
			// trace('rads: ' + (rads));
			var dx : Number = _centerX - touchX;
			var dy : Number = _centerY - touchY;
			var distance : Number = Math.sqrt(dx * dx + dy * dy);
			//var distance : Number = getDistance(centerX, centerY, touchX, touchY);
			
			// trace('distance: ' + (distance));
			// reset key codes
			_keyCodeA = _keyCodeB = 0;

			// check within dpad active radius
			if (distance > _minDistance && distance < _maxDistance) {
				if (_is8Way) {
					getKeyCode8Way(rads);
				} else {
					getKeyCode4Way(rads);
				}
			}
			// dispatch key up for previous keys
			if (_previousKeyCodeA != _keyCodeA) {
				dispatchKeyUp(_previousKeyCodeA);
				_previousKeyCodeA = _keyCodeA;
			}
			if (_previousKeyCodeB != _keyCodeB) {
				dispatchKeyUp(_previousKeyCodeB);
				_previousKeyCodeB = _keyCodeB;
			}
			// dispatch key down for keys pressed
			if (_keyCodeA > 0) {
				dispatchKeyDown(_keyCodeA);
			}
			if (_keyCodeB > 0) {
				dispatchKeyDown(_keyCodeB);
			}
		}

		private function getKeyCode8Way(rads : Number) : void {
			if (rads >= R && rads < DR) {
				_keyCodeA = Keyboard.RIGHT;
			} else if (rads >= D && rads < DL) {
				_keyCodeA = Keyboard.DOWN;
			} else if ((rads >= L && rads <= Math.PI) || (rads >= -Math.PI && rads < UL)) {
				_keyCodeA = Keyboard.LEFT;
			} else if (rads >= U && rads < UR) {
				_keyCodeA = Keyboard.UP;
			} else if (rads >= UL && rads < U) {
				_keyCodeA = Keyboard.UP;
				_keyCodeB = Keyboard.LEFT;
			} else if (rads >= DL && rads < L) {
				_keyCodeA = Keyboard.DOWN;
				_keyCodeB = Keyboard.LEFT;
			} else if (rads >= UR && rads < R) {
				_keyCodeA = Keyboard.UP;
				_keyCodeB = Keyboard.RIGHT;
			} else if (rads >= DR && rads < D) {
				_keyCodeA = Keyboard.DOWN;
				_keyCodeB = Keyboard.RIGHT;
			}
		}

		private function getKeyCode4Way(rads : Number) : void {
			if (rads >= RIGHT && rads < DOWN) {
				_keyCodeA = Keyboard.RIGHT;
			} else if (rads >= DOWN && rads < LEFT) {
				_keyCodeA = Keyboard.DOWN;
			} else if ((rads >= LEFT && rads <= Math.PI) || (rads >= -Math.PI && rads < UP)) {
				_keyCodeA = Keyboard.LEFT;
			} else if (rads >= UP && rads < RIGHT) {
				_keyCodeA = Keyboard.UP;
			}
		}

		private function dispatchKeyDown(keyCode : uint) : void {
			_keyDownEvent.keyCode = keyCode;
			FP.stage.dispatchEvent(_keyDownEvent);
		}

		private function dispatchKeyUp(keyCode : uint) : void {
			_keyUpEvent.keyCode = keyCode;
			FP.stage.dispatchEvent(_keyUpEvent);
		}

//		private function getDistance(x1 : Number, y1 : Number, x2 : Number, y2 : Number) : Number {
//			var dx : Number = x1 - x2;
//			var dy : Number = y1 - y2;
//			return Math.sqrt(dx * dx + dy * dy);
//		}

		// mouse input for testing
		private function onMouseDown(event : MouseEvent) : void {
			if (collidePoint(this.x, this.y, Input.mouseX, Input.mouseY)) {
				FP.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}
		}

		private function onMouseUp(event : MouseEvent) : void {
			if (_keyCodeA > 0) {
				dispatchKeyUp(_keyCodeA);
			}
			if (_keyCodeB > 0) {
				dispatchKeyUp(_keyCodeB);
			}
			FP.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_keyCodeA = _keyCodeB = 0;
		}

		private function onEnterFrame(event : Event) : void {
			calculateTouches(Input.mouseX, Input.mouseY);
		}
	}
}
