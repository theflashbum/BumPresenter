package com.flashbum.components.containers.pv3d 
{
	import com.flashbum.components.ui.DecalVideoPlayer;

	import flash.display.Bitmap;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author jessefreeman
	 */
	public class VideoImageContainer extends ImageContainer 
	{

		protected var vsrc : String;
		protected var videoDisplay : DecalVideoPlayer;

		public function VideoImageContainer(id : String, xmlData : XML = null)
		{
			super( id, xmlData );
		}

		override public function parseXML(data : XML) : void
		{
			vsrc = data.@vsrc;
			super.parseXML( data );
		}
		
		override protected function onLoadComplete(event : Event) : void
		{
			var bitmap : Bitmap = LoaderInfo( event.target ).content as Bitmap;
			
			imageDecal.bitmapData = bitmap.bitmapData;
			
			// Here we create a new Video player and pass in the Container's ID 
			// plus the name of the "Component" so we can style this instance
			// specifically if we wanted to. 
			videoDisplay = new DecalVideoPlayer( id+"DecalVideoPlayer", imageDecal );
			frontMaterial.addDecalBitmap("videoPlayer", videoDisplay, new Point(0,0));
			removeLoadEventListeners( event.target as LoaderInfo );
		}

		override protected function onActive() : void
		{
			super.onActive( );
			videoDisplay.src = vsrc;
		}

		override protected function onDeactivate() : void
		{
			videoDisplay.stop( );
			super.onDeactivate( );
		}
	}
}
