package {
	import net.flashpunk.World;

	import org.alwaysinbeta.games.ui.Dpad;
	import org.alwaysinbeta.games.ui.TouchKey;

	import flash.ui.Keyboard;

	/**
	 * @author ian
	 */
	public class World8Way extends World {
		public function World8Way() {
			add(new Player());
			add(new Dpad(20, 300, true));
			add(new TouchKey(600, 360, Keyboard.X, 0xFF0000));
			add(new TouchKey(700, 360, Keyboard.C, 0x00FF00));
		}
	}
}
