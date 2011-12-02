package {
	import net.flashpunk.FP;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;

	/**
	 * @author McFamily
	 */
	public class Player extends Entity {
		[Embed(source = '/assets/walk.png')]
		private const STICKMAN : Class;
		private var _stickman : Spritemap;

		public function Player() {
			_stickman = new Spritemap(STICKMAN, 74, 172);
			_stickman.add("stand", [1], 0, true);
			_stickman.add("walk", [2, 3, 4, 5, 1], 14, true);
			graphic = _stickman;

			x = y = 100;
			setHitbox(_stickman.width, _stickman.height);

			_stickman.play("stand");
		}

		override public function update() : void {
			var left : Boolean = Input.check(Key.LEFT);
			var right : Boolean = Input.check(Key.RIGHT);
			var up : Boolean = Input.check(Key.UP);
			var down : Boolean = Input.check(Key.DOWN);

			var speed : int = 10;

			if (left) {
				x -= speed;
				_stickman.flipped = true;
			} else if (right) {
				x += speed;
				_stickman.flipped = false;
			}

			if (up) {
				y -= speed;
			} else if (down) {
				y += speed;
			}

			if (left || right || up || down) {
				_stickman.play("walk");
			} else {
				_stickman.play("stand");
			}

			if (x > FP.width) {
				x = 0 - _stickman.width;
			} else if (x < 0 - _stickman.width) {
				x = FP.width;
			}

			if (y > FP.height) {
				y = 0 - _stickman.height;
			} else if (y < 0 - _stickman.height) {
				y = FP.height;
			}
		}
	}
}
