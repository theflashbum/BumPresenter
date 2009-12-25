
package com.flashbum.core.pv3d.materials 
{
	import camo.core.decal.BaseDecal;
	import camo.core.decal.IBaseDecal;

	import com.flashbum.core.IDecalMaterial;

	import org.papervision3d.materials.BitmapMaterial;

	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * @author jessefreeman
	 */
	public class DecalPv3DMaterial extends BitmapMaterial implements IDecalMaterial
	{

		private static const DEFAULT_DECAL : String = "defaultDecal";
		private var decals : Array = [];
		private var renderLayers : Array = [];
		private var decalPositions : Array = [];
		private var _buttonHitAreas : Array = [];
		private var tempDecalRect : Rectangle = new Rectangle( );
		private var decalRects : Dictionary = new Dictionary( true );

		public function DecalPv3DMaterial(defaultDecal : IBaseDecal, precise : Boolean = false)
		{

			addDecalBitmap( DEFAULT_DECAL, defaultDecal, new Point( 0, 0 ), false, true, true );
			
			super( new BitmapData( defaultDecal.width, defaultDecal.height ), precise );
			
			render( );
		}

		public function addDecalBitmap(name : String, decal : IBaseDecal, position : Point, interactive : Boolean = false, render : Boolean = true, autoUpdate : Boolean = true) : IBaseDecal
		{
			decals[name] = decal;
			
			tempDecalRect.x = 0;
			tempDecalRect.y = 0;
			tempDecalRect.width = decal.width;
			tempDecalRect.height = decal.height;
			
			decalRects[decal] = tempDecalRect.clone( );
			
			if(interactive)
			{
				tempDecalRect.x = position.x;				tempDecalRect.y = position.y;
				
				registerHitArea( name, tempDecalRect.clone( ) );
			}
			
			if(autoUpdate)
				addDecalChangeListener( decal );
				
			if(render)
			{
				renderLayers.push( decal );
				decalPositions.push( position );
			}
			
			return decal;
		}

		protected function registerHitArea(id : String, rect : Rectangle) : void
		{
			trace( "DecalPv3DMaterial.registerHitArea(", id, ",", rect, ")" );
			buttonHitAreas[id] = rect;
		}

		public function removeDecalByName(name : String) : void
		{
		}

		public function removeDecalByInstance(decal : IBaseDecal) : void
		{
		}

		public function detach() : void
		{
		}

		public function detachByInstance(...decals ) : void
		{
		}

		public function detachByName(...decalNames ) : void
		{
		}

		protected function addDecalChangeListener(decal : IBaseDecal) : void
		{
			decal.addEventListener( Event.CHANGE, onDecalChange, false, 0, true );
		}

		protected function removeDecalChangeListener(decal : IBaseDecal) : void
		{
			decal.removeEventListener( Event.CHANGE, onDecalChange );
		}

		private function onDecalChange(event : Event) : void
		{
			render( );
		}

		public function render() : void
		{
			
			var total : int = renderLayers.length;
			var point : Point;
			var rect : Rectangle;
			var bitmapData : BitmapData;
			var decal : BaseDecal;
			var i : int;
			
			for (i = 0; i < total; i ++) 
			{
				decal = renderLayers[i];				bitmapData = decal.bitmapData;
				if(bitmapData)
				{
					point = decalPositions[i];
					rect = decalRects[decal];
					bitmap.copyPixels( bitmapData, rect, point, null, null, true );
				}
			}
		}

		public function get buttonHitAreas() : Array
		{
			return _buttonHitAreas;
		}
		
		public function get isInteractive() : Boolean
		{
			
			return interactive;
		}
		
		public function set isInteractive(value : Boolean) : void
		{
			interactive = value;
		}
		
		public function get bitmapData() : BitmapData
		{
			return bitmap;
		}
		
		public function set bitmapData(value: BitmapData):void
		{
			bitmap = value;
		}
		
		public function get isDoubleSided() : Boolean
		{
			return doubleSided;
		}
		
		public function set isDoubleSided(value : Boolean) : void
		{
			doubleSided = value;
		}
	}
}
