
package com.flashbum.core.pv3d.materials 
{
	import camo.core.decal.DecalSheet;

	import org.papervision3d.materials.utils.MaterialsList;

	/**
	 * @author jessefreeman
	 * 
	 * This will not work unil my patch to Pv3d is implemented.
	 * 
	 */
	public class Pv3dDecalSheetMaterialList extends MaterialsList 
	{

		protected var decalSheet : DecalSheet;

		public function Pv3dDecalSheetMaterialList(decalSheet : DecalSheet, nameMap : Object = null)
		{
			this.decalSheet = decalSheet;
			super( nameMap );
		}

//		override protected function parseMaterials(nameMap : * = null) : void
//		{
//			var decals : Array = decalSheet.decalNames;
//			
//			for each (var value:String in decals)
//			{
//				var decalName : String = value;
//				var decal : Decal = decalSheet.getDecal( decalName );
//				var tempMat : BitmapMaterial = new BitmapMaterial( decal.bitmapData );
//				    
//				addMaterial( tempMat, (nameMap) ? nameMap[decalName] : decalName );
//			}			
//		}
	}
}
