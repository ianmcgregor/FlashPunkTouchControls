package {
	import net.flashpunk.Engine;
	import net.flashpunk.FP;

	/**
	 * @author ian
	 */
	public class Main extends Engine {
		public function Main() {
			super(800, 480, 60, false);

			FP.world = new MyWorld();
			FP.console.enable();
		}
	}
}
