
package com.flashbum.core.pv3d 
{
	import com.flashbum.components.containers.I3dContainer;

	import Boolean;
	import com.flashbum.components.containers.IDoubleSidedContainer;
	import com.flashbum.core.pv3d.CardboardVisionPv3d;

	/**
	 * @author jessefreeman
	 */
	public class AutoFlipCardboardVisionPv3d extends CardboardVisionPv3d 
	{

		public function AutoFlipCardboardVisionPv3d(displayStats:Boolean = false)
		{
			super( displayStats );
		}

		override public function next():void
		{
			if(currentContainer is IDoubleSidedContainer)
			{
				if(currentContainer["front"] == true)
				{
					selectContainer( currentContainer.id, "back" );
				}
				else
				{
					super.next( );
				}
			}
			else
			{
				super.next( );
			}
		}

		/**
		 * <p>This can select a container by it's index number.</p>
		 */
		override protected function selectContainerByIndex(index:Number):void 
		{
			var containerInstance:I3dContainer = containerInstances[index];
			var side:String = "front";
			if(containerInstance is IDoubleSidedContainer)
			{
				side = containerInstance["front"] ? "front" : "back";	
			}
			selectContainer( containerInstance.id, side );
		}

		override public function back():void
		{
			if(currentContainer is IDoubleSidedContainer)
			{
				if(currentContainer["front"] == false)
				{
					selectContainer( currentContainer.id, "front" );
				}
				else
				{
					super.back( );
				}
			}
			else
			{
				super.back( );
			}
		}
	}
}
