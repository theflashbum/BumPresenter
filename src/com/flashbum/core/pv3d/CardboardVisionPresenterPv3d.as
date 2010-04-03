package com.flashbum.core.pv3d
{
    import com.flashbum.components.containers.I3dContainer;
    import com.flashbum.components.containers.IDoubleSidedContainer;

    /**
     * @author jessefreeman
     */
    public class CardboardVisionPresenterPv3d extends CardboardVisionPv3d
    {

        public function CardboardVisionPresenterPv3d(displayStats:Boolean = false)
        {
            super(displayStats);
        }

        override public function next():void
        {
            if (currentContainer is IDoubleSidedContainer)
            {
                if (currentContainer["front"] == true)
                {
                    selectContainer(currentContainer.id, "back");
                }
                else
                {
                    super.next();
                }
            }
            else
            {
                super.next();
            }
        }

        /**
         * <p>This can select a container by it's index number.</p>
         */
        override protected function selectContainerByIndex(index:Number):void
        {
            var containerInstance:I3dContainer = containerInstances[index];
            var side:String = "front";
            if (containerInstance is IDoubleSidedContainer)
            {
                side = containerInstance["front"] ? "front" : "back";
            }
            selectContainer(containerInstance.id, side);
        }

        override public function back():void
        {
            if (currentContainer is IDoubleSidedContainer)
            {
                if (currentContainer["front"] == false)
                {
                    selectContainer(currentContainer.id, "front");
                }
                else
                {
                    super.back();
                }
            }
            else
            {
                super.back();
            }
        }

        override protected function instantiateContainer(className:String, data:XML, tempContainer:I3dContainer):I3dContainer {
            //TODO need to add logic to parse out thumbnail
            return super.instantiateContainer(className, data, tempContainer);
        }
    }
}
