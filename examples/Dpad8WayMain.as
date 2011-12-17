package {
	import net.flashpunk.Engine;
	import net.flashpunk.FP;

	/**
	 * @author ian
	 */
	public class Dpad8WayMain extends Engine {
		public function Dpad8WayMain() {
			super(800, 480, 60, false);
			FP.screen.color = 0xFFFFFF;
			FP.world = new World8Way();
			FP.console.enable();
		}
	}
}
