package
{
    import camo.core.decal.Decal;

    import com.flashbum.core.pv3d.AutoFlipCardboardVisionPv3d;

    import flash.display.DisplayObject;
    import flash.display.StageDisplayState;
    import flash.display.StageQuality;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;

    /**
     * @author jessefreeman
     */
    public class BumPresenter extends AbstractBumEngine
    {

        private var includedClasses:IncludeClasses;
        private var bug:Decal;

        public function BumPresenter()
        {
            stage.quality = StageQuality.LOW;
            super();
        }

        override protected function createCardboardVision():void
        {
            defaultLocation = "intro";

            // Creates 3d Engine instance
            cardboardVision = new AutoFlipCardboardVisionPv3d(false);
            addChild(cardboardVision as DisplayObject);
        }

        override protected function onStageResize(event:Event):void
        {
            super.onStageResize(event);

            realignBug();
        }

        protected function realignBug():void
        {
            try
            {
                if (contains(bug))
                {
                    bug.x = stage.stageWidth - bug.width;
                    bug.y = stage.stageHeight - bug.height;
                }
            }
            catch(error:Error)
            {
                // Something is missing and we can't move the dirt into position.
            }
        }

        override protected function init():void
        {
            super.init();

            // KeyboardShortcuts
            addKeyboardShortcuts();

            // Creates Dirt Overlay
            createCornerDirt();
        }

        protected function createCornerDirt():void
        {

            try
            {
                bug = decalSheetManager.getDecal("bug");

                addChild(bug);

                realignBug();
            }
            catch (error:Error)
            {
                // decal was not found
            }
        }

        protected function addKeyboardShortcuts():void
        {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
        }

        protected function keyDownHandler(event:KeyboardEvent):void
        {
            switch (event.keyCode)
            {
                case 39:
                    cardboardVision.next();
                    break;
                case 37:
                    cardboardVision.back();
                    break;
                case(70):
                    goFullScreen();
                    break;
            }

            //For debug right now
            trace("keyDownHandler: " + event.keyCode);
        }

        protected function goFullScreen():void
        {
            if (stage.displayState == StageDisplayState.NORMAL)
            {
                stage.displayState = StageDisplayState.FULL_SCREEN;
            }
            else
            {
                stage.displayState = StageDisplayState.NORMAL;
            }
        }

        protected function _handleClick(event:MouseEvent):void
        {
            goFullScreen();
        }
    }
}
