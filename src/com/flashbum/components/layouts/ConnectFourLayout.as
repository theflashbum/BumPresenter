
package com.flashbum.components.layouts 
{
	import com.flashbum.components.containers.I3dContainer;
	import com.flashbum.utils.MathUtil;

	/**
	 * @author Jesse Freeman aka @theFlashBum | http://jessefreeman.com
	 * 
	 * This still needs to be optimized but not bad for a quick sketch...
	 * 
	 */
	public class ConnectFourLayout extends AbstractLayout
	{

		private var columnWidths : Array;
		private var columnHeights : Array;
		private var columns : Array;
		

		override protected function layoutContainers() : void 
		{
			
			var total : int = columns.length;
			var nextX : Number = 0;
			
			// Mabe use a while(array.length > 0) {
			for (var i : int = 0; i < total ; i ++) 
			{
				var totalItems : int = columns[i].length;
				var columnWidth : Number = columnWidths[i];
				var nextY : Number = Math.floor( (maxHeight - columnHeights[i]) * .5 );
				
				for (var j : int = 0; j < totalItems ; j ++) 
				{
					var tempItem : I3dContainer = columns[i][j];
					tempItem.x += nextX;
					tempItem.y = nextY;
					tempItem.rotationZ = MathUtil.randRange( - 30, 30 );
					nextY += tempItem.height + space;
				}
				
				nextX += columnWidth + space;
			}
			maxWidth = nextX;
		}

		override protected function indexContainers() : void 
		{
			columns = new Array( );
			maxHeight = 0;
			columnWidths = new Array( );
			columnHeights = new Array( );

			var total : int = containerInstances.length;
			var counter : Number = 0;
			var column : Number = 0;
			
			for (var i : int = 0; i < total ; i ++) 
			{
				var maxSelections : Number = 4;
				var selections : Number = MathUtil.randRange( 1, maxSelections );
				var selected : Array = containerInstances.splice( 0, selections );
				
				indexColumn( selected );
				
				i = 0;
				total = containerInstances.length;
				counter += selections;
				column ++;
			}
			
			if(containerInstances.length > 0)
				indexColumn( containerInstances );
		}

		public function indexColumn(items : Array ) : void 
		{
			var columnHeight : Number = 0;
			var columnWidth : Number = 0;
			
			var total : int = items.length;
			
			var currentContainer : I3dContainer;
			for (var i : int = 0; i < total ; i ++) 
			{
				currentContainer = items[i];
				columnHeight += currentContainer.height;
				columnWidth = MathUtil.compareValues( currentContainer.width, columnWidth );
			}
			
			maxHeight = MathUtil.compareValues( columnHeight, maxHeight );
			columns.push( items );
			columnWidths.push( columnWidth );
			columnHeights.push( columnHeight );
		}

		private function center(target : I3dContainer, boundryW : Number) : void 
		{
			target.x = (boundryW * .5) - (target.width * .5);
		}
	}
}
