
package com.flashbum.components.containers.pv3d 
{
	import camo.core.decal.BaseDecal;

	import com.flashbum.components.ui.DecalVideoPlayer;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;

	/**
	 * @author jessefreeman
	 */
	public class ImageVideoPlayerContainer extends ImageContainer 
	{

		protected var vsrc : String;
		protected var videoDisplay : DecalVideoPlayer;
		protected var posterFrameSrc : String;
		private var posterFrameDecal : BaseDecal;
		private var playFlag : Boolean;

		public function ImageVideoPlayerContainer(id : String = "ImageVideoPlayerContainer", xmlData : XML = null)
		{
			super( id, xmlData );
			
			trace("***",id);
		}
		
		override public function parseXML(data : XML) : void
		{
			vsrc = data.@vsrc;
			posterFrameSrc = data.@posterframe;
			super.parseXML( data );
		}

		override protected function onLoadComplete(event : Event) : void
		{
			
			super.onLoadComplete( event );
			
			if(posterFrameSrc)
			{
				var loader : Loader = new Loader( );
				addPosterFrameLoadEventListeners( loader.contentLoaderInfo );
				loader.load( new URLRequest( posterFrameSrc ) );
			}
		}

		/**
		 * 
		 */
		protected function addPosterFrameLoadEventListeners(contentLoaderInfo : LoaderInfo) : void
		{
			contentLoaderInfo.addEventListener( Event.COMPLETE, onPosterFrameLoadComplete );
		}

		/**
		 * 
		 */
		protected function removePosterFrameLoadEventListeners(contentLoaderInfo : LoaderInfo) : void
		{
			contentLoaderInfo.removeEventListener( Event.COMPLETE, onPosterFrameLoadComplete );
		}

		private function onPosterFrameLoadComplete(event : Event) : void
		{
			var bitmap : Bitmap = LoaderInfo( event.target ).content as Bitmap;
			
			posterFrameDecal = new BaseDecal( new BitmapData( bitmap.width, bitmap.height, true, 0x000000 ) );
			
			posterFrameDecal.bitmapData = bitmap.bitmapData;
			
			videoDisplay = new DecalVideoPlayer( id+"DecalVideoPlayer", posterFrameDecal );
			
			var vdX:Number = (width *.5) - (videoDisplay.width * .5);			var vdY:Number = (height *.5) - (videoDisplay.height * .5)+30;
			
			frontMaterial.addDecalBitmap( "videoPlayer", videoDisplay, new Point( vdX, vdY ) );
			removeLoadEventListeners( event.target as LoaderInfo );
			
			if(playFlag)
				videoDisplay.src = vsrc;
		}

		override protected function onActive() : void
		{
			super.onActive( );
			if(videoDisplay)
				videoDisplay.src = vsrc;
			else
				playFlag = true;
		}

		override protected function onDeactivate() : void
		{
			if(videoDisplay)
				videoDisplay.stop( );
			super.onDeactivate( );
		}
	}
}
