package {
	import net.flashpunk.Engine;
	import net.flashpunk.FP;

	/**
	 * @author ian
	 */
	public class Dpad4WayMain extends Engine {
		public function Dpad4WayMain() {
			super(800, 480, 60, false);
			FP.screen.color = 0xFFFFFF;
			FP.world = new World4Way();
			FP.console.enable();
		}
	}
}
