
package com.flashbum.components.containers.pv3d 
{
	import flash.geom.Matrix;

	import camo.core.decal.BaseDecal;

	import gs.TweenLite;
	import gs.easing.Elastic;

	import com.flashbum.components.containers.IDoubleSidedContainer;
	import com.flashbum.components.containers.pv3d.ImageContainer;
	import com.flashbum.core.IDecalMaterial;
	import com.flashbum.events.ContainerEvent;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;

	/**
	 * @author jessefreeman
	 */
	public class DoubleSidedImageContainer extends ImageContainer implements IDoubleSidedContainer 
	{

		protected var src2:String;
		private var backMaterial:IDecalMaterial;
		private var backImageDecal:BaseDecal;
		private var _flipping:Boolean;
		private var _front:Boolean = true;
		private var canFlip:Boolean = true;

		public function DoubleSidedImageContainer(id:String, xmlData:XML = null)
		{
			super( id, xmlData );
		}

		override protected function createObject():void
		{
			super.createObject( );
			createBackMaterial( );
		}

		override public function parseXML(data:XML):void
		{
			_src = data.container.(@side == "front")[0].@src;
			
			src2 = data.container.(@side == "back")[0].@src;
			
			$parseXML( data );
		}

		protected function createBackMaterial():void
		{
			
			var loader:Loader = new Loader( );
			addBackLoadEventListeners( loader.contentLoaderInfo );
			
			backImageDecal = new BaseDecal( new BitmapData( width, height, imageDecalTransparent, backgroundColor ) );
			
			backMaterial = createDecalMaterial( backImageDecal );
			
			backMaterial.isInteractive = true;
			backMaterial.isDoubleSided = true;
			
			loader.load( new URLRequest( src2 ) );
		}

		/**
		 * 
		 */
		protected function addBackLoadEventListeners(contentLoaderInfo:LoaderInfo):void
		{
			contentLoaderInfo.addEventListener( Event.COMPLETE, onBackLoadComplete );
		}

		/**
		 * 
		 */
		protected function removeBackLoadEventListeners(contentLoaderInfo:LoaderInfo):void
		{
			contentLoaderInfo.removeEventListener( Event.COMPLETE, onBackLoadComplete );
		}

		/**
		 * 
		 */
		protected function onBackLoadComplete(event:Event):void
		{
			var bitmap:Bitmap = LoaderInfo( event.target ).content as Bitmap;
			
			var flipBMD:BitmapData = new BitmapData( bitmap.width, bitmap.height, imageDecalTransparent, backgroundColor );
			
			var matrix:Matrix = new Matrix( );
			matrix.translate( - bitmap.width, 0 );
			matrix.scale( - 1, 1 );
			flipBMD.draw( bitmap, matrix );
			
			backImageDecal.bitmapData = flipBMD;
			
			removeBackLoadEventListeners( event.target as LoaderInfo );
		}

		public function flip(animated:Boolean = true, recenterRotationX:Boolean = false):void
		{
			trace( "Flip Works" );
			if(canFlip)
			{
				_flipping = true;
				currentFocus = null;
				
				var newRotationY:Number = front ? - 180 : 0;
				
				if(animated)
				{
					//TODO replace with TweenLite
					if(recenterRotationX)
					{
						TweenLite.to( this, 1.5, {rotationX: 0, ease: Elastic.easeInOut, onUpdate: onFlipUpdate, onComplete: onFlipComplete, overwrite:false} );
						//Tweener.addTween( this, {rotationX: 0, time: 1.5, transition: "easeInOutElastic", onUpdate: onFlipUpdate, onComplete: onFlipComplete} );
					}
					//Tweener.addTween( this, {rotationY: newRotationY, time: 1.5, transition: "easeInOutElastic", onUpdate: onFlipUpdate, onComplete: onFlipComplete} );
					TweenLite.to( this, 1.5, {rotationY: newRotationY, ease: Elastic.easeInOut, onUpdate: onFlipUpdate, onComplete: onFlipComplete, overwrite:false} );
					//flipBend( );
				}
				else
				{
					if(recenterRotationX) rotationX = 0;
					rotationY = newRotationY;
				}
			}
		}

		public function get flipping():Boolean
		{
			return _flipping;
		}

		public function set flipping(flipping:Boolean):void
		{
			_flipping = flipping;
		}

		override public function get front() : Boolean
		{
			return _front;
		}

		public function set front(value : Boolean) : void
		{
			if(_front != value)
			{
				_front = value;
				if(_front)
				{
					onFront( );
				}
				else
				{
					onBack( );	
				}
//				if(flipBendFlag)
//				{
//					flipBend( );
//					flipBendFlag = false;	
//				}
			}
		}

		/**
		 * <p>Manages the rotation of the object and flags if the front/back is
		 * showing.</p>
		 */
		override public function set rotationY(value:Number):void
		{
			super.rotationY = value;
			
			if(rotationY >= - 90 && rotationY <= 90)
			{
				if(! front) front = true;
			}
			else
			{
				if(front) front = false;
			}
		}
		
		override protected function onDeactivate() : void
		{
			removeButtonHitAreaListeners( );
			//resetXY( );
		}
		
		/**
		 * This method is called everytime Tweener updates while flipping.
		 * 
		 */
		protected function onFlipUpdate():void
		{
		}

		/**
		 * 
		 */
		protected function onFlipComplete():void
		{
			_flipping = false;
			dispatchEvent( new ContainerEvent( ContainerEvent.END_FLIP, true, true ) );
		}

		protected function onFront():void
		{
			_instance.material = frontMaterial;
			front = true;
			dispatchEvent( new ContainerEvent( ContainerEvent.FRONT_SIDE, true, true ) );
		}

		protected function onBack():void
		{
			trace("DoubleSidedImageContainer.onBack()");
			_instance.material = backMaterial;
			front = false;
			dispatchEvent( new ContainerEvent( ContainerEvent.BACK_SIDE, true, true ) );			
		}

		override public function view(...params):void
		{
			var side:String = params.shift( );
			var newRotationY:Number;
			if(side == "front")
			{
				newRotationY = 0;
			}
			else
			{
				newRotationY = - 180;
			}
			TweenLite.to( this, 1.5, {rotationY: newRotationY, ease: Elastic.easeInOut, onUpdate: onFlipUpdate, onComplete: onFlipComplete, overwrite:false} );
			//Tweener.addTween( this, {rotationY: newRotationY, time: 1.5, transition: "easeInOutElastic", onUpdate: onFlipUpdate, onComplete: onFlipComplete} );
		}
	}
}
