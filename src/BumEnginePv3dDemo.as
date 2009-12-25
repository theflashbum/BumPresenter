package 
{
	import com.flashbum.core.pv3d.CardboardVisionPv3d;

	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;

	/**
	 * @author jessefreeman
	 */
	public class BumEnginePv3dDemo extends AbstractBumEngine {
		public function BumEnginePv3dDemo() {

            super();
		}

		override protected function createCardboardVision() : void {
			defaultLocation = "intro";

            // Creates 3d Engine instance
			cardboardVision = new CardboardVisionPv3d(false);
			addChild(cardboardVision as DisplayObject);
		}

		protected function addKeyboardShortcuts() : void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}

		override protected function init() : void {
			super.init();
			
			// KeyboardShortcuts
			addKeyboardShortcuts();
		}

		protected function keyDownHandler(event : KeyboardEvent) : void {
			switch(event.keyCode) {
				case 39:
					cardboardVision.next();
					break;
				case 37:
					cardboardVision.back();
					break;
			}
			
			//For debug right now
			trace("keyDownHandler: " + event.keyCode);
		}
	}
}
