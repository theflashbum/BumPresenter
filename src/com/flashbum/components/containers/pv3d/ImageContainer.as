
package com.flashbum.components.containers.pv3d 
{
	import camo.core.decal.IBaseDecal;

	import com.flashbum.components.containers.BaseImageContainer;
	import com.flashbum.core.IDecalMaterial;
	import com.flashbum.core.pv3d.materials.DecalPv3DMaterial;

	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.objects.primitives.Plane;

	/**
	 * @author jessefreeman
	 */
	public class ImageContainer extends BaseImageContainer 
	{
//		override protected function applyModifier() : void
//		{
//			mstack = new ModifierStack( new LibraryPv3d( ), _instance );
//			
//			super.applyModifier( );
//		}
		
		public function ImageContainer(id : String, xmlData : XML = null)
		{
			super( id, xmlData );
		}

		override protected function createDecalMaterial(decal:IBaseDecal) : IDecalMaterial
		{
			return new DecalPv3DMaterial( decal, _percise );
		}

		override protected function create3dObject() : *
		{
			return new Plane( frontMaterial as BitmapMaterial, width, height, _segmentsW, _segmentsH );
		}
		
		override protected function addButtonHitAreaListeners() : void
		{
			instance.addEventListener( InteractiveScene3DEvent.OBJECT_MOVE, handleMouseMove );
			instance.addEventListener( InteractiveScene3DEvent.OBJECT_PRESS, handleMouseDown );
			instance.addEventListener( InteractiveScene3DEvent.OBJECT_OUT, onMouseOut );
		}

		override protected function removeButtonHitAreaListeners() : void
		{
			instance.removeEventListener( InteractiveScene3DEvent.OBJECT_MOVE, handleMouseMove );
			instance.removeEventListener( InteractiveScene3DEvent.OBJECT_PRESS, handleMouseDown );
			instance.removeEventListener( InteractiveScene3DEvent.OBJECT_OUT, onMouseOut );
		}
	}
}
