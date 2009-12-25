
package com.flashbum.core.pv3d 
{
	import com.flashartofwar.bootstrap.managers.SettingsManager;
	import gs.TweenLite;
	import gs.easing.Quart;

	import com.flashbum.components.containers.I3dContainer;
	import com.flashbum.components.containers.pv3d.PV3dIncludedClasses;
	import com.flashbum.core.AbstractCardboardVision;
	import com.flashbum.enum.Sides;

	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.view.stats.StatsView;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * @author jessefreeman
	 */
	public class CardboardVisionPv3d extends AbstractCardboardVision 
	{

		private var incudedClasses : PV3dIncludedClasses;
		protected var scene : Scene3D;
		protected var camera : Camera3D;
		protected var viewport : Viewport3D;
		protected var renderer : BasicRenderEngine;
		protected var displayStats : Boolean;
		protected var baseNode : DisplayObject3D;

		public function CardboardVisionPv3d(displayStats : Boolean = false)
		{
			debug = displayStats;
			super( );
		}

		override protected function init() : void
		{
			containerBasePackage = "com.flashbum.components.containers.pv3d.";
			super.init( );
		}

		override public function render() : void 
		{
			
			super.render( );
			
			renderer.renderScene( scene, camera, viewport );
		}

		/**
		 * <p>Sets up and configures papervision. This function can be overriden
		 * to accomidate any custom set ups you may need for your project.</p>
		 * 
		 */			
		override protected function setup3dEngine() : void 
		{
			super.setup3dEngine( );
			
			scene = new Scene3D( );
			camera = new Camera3D( );
			
			// Create the Viewport
			viewport = new Viewport3D( 800, 600, true, true, true, true );
			addChild( viewport );
			
			// Camera goodness
			camera.focus = 100;
			camera.zoom = 11;
			camera.useCulling = true;
			camera.near = 100;
			camera.far = 7000;
			
			renderer = new BasicRenderEngine( );
			
			baseNode = scene.addChild( new DisplayObject3D( ) );

			camera.z = (zoomLevel * zoomAmount - 1);			//baseNode.z = - (zoomLevel * zoomAmount - 1);
			
			if(debug)
				addChild( new StatsView( renderer ) );
		}

		override protected function addContainerMouseListeners(target : IEventDispatcher) : void 
		{
			target.addEventListener( InteractiveScene3DEvent.OBJECT_OVER, onContainerOver, false, 0, true );	
			target.addEventListener( InteractiveScene3DEvent.OBJECT_OUT, onContainerOut, false, 0, true );	
			target.addEventListener( InteractiveScene3DEvent.OBJECT_PRESS, onContainerClick, false, 0, true );	
		}

		/**
		 * 
		 */
		override protected function removeContainerMouseListeners(target : IEventDispatcher) : void 
		{
			target.removeEventListener( InteractiveScene3DEvent.OBJECT_OVER, onContainerOver );	
			target.removeEventListener( InteractiveScene3DEvent.OBJECT_OUT, onContainerOut );	
			target.removeEventListener( InteractiveScene3DEvent.OBJECT_PRESS, onContainerClick );	
		}

		override protected function onContainerClick(event : Event) : void 
		{
			selectContainer( idByContainerInstance[InteractiveScene3DEvent( event ).displayObject3D] );
		}

		override protected function attachContainer(id : String, target : I3dContainer) : void
		{
			var container : I3dContainer = target as I3dContainer;
			
			addContainerMouseListeners( container.instance );
					
			container.attachTo( baseNode );
			
			// Use this to find an id bu the 3d object instance
			idByContainerInstance[container.instance] = id;
		}

		override protected function removeContainer(target : I3dContainer) : void
		{
			super.removeContainer( target );
			
			var container : I3dContainer = target;
			
			
			removeContainerMouseListeners( container.instance );
			container.removeFrom( baseNode );
			container.destroy( );
			container = null;
		}

		override protected function moveToContainer(...params) : void 
		{
			super.moveToContainer.apply( this, params );
			
			var id : String = params[0];			var side : String = (params[1]) ? params[1] : Sides.FRONT;			var mode : String = (params[2]) ? params[2] : CONTAINER_VIEW_MODE;
			
			
			var target : I3dContainer = indexByID[id];

			panCamera( target.x, target.y, - (camera.zoom * camera.focus) - Math.abs( target.z )-SettingsManager.instance.zoomOffset, target.rotationZ, 1, .5, [ id, side, mode ] );
			
			//panCamera( -(target.x - layout.width*.5), - (target.y - layout.height*.5), 0, 0, 1, .5, [ id, side, mode ] );
		}

		override public function panCamera(x : Number, y : Number, z : Number, rotation : Number = 0, time : Number = 1, delay : Number = .5, completeParams : Array = null) : void
		{
			TweenLite.to( camera, time, {x: x, y: y, rotationZ: rotation, delay: delay, ease: Quart.easeInOut, overwrite:false} );
			
			TweenLite.to( camera, 1, {z:z, delay: delay + delay, ease: Quart.easeOut, onComplete: onCameraFocused, onCompleteParams: completeParams, overwrite:false} );
			
			//Trying to move the baseNode instead of camera. Doesn't work with rotation.
			//TweenLite.to( baseNode, time, {x: x, y: y, rotationZ: rotation, delay: delay, ease: Quart.easeInOut, overwrite:false} );
			//TweenLite.to( baseNode, 1, {z:z, delay: delay + delay, ease: Quart.easeOut, onComplete: onCameraFocused, onCompleteParams: completeParams, overwrite:false} );
		}

		override protected function layoutContainers() : void
		{
			super.layoutContainers( );
			
			camera.x = layout.width * .5;
			camera.y = layout.height * .5;
		}

		override protected function clearFocus() : void
		{
			super.clearFocus( );
			camera.target = null;
		}

		override protected function tweenCameraZ(z : Number, speed : Number = 1, delay : Number = 0) : void
		{
			TweenLite.to( camera, speed, {z: z, delay:delay, ease: Quart.easeInOut} );			//TweenLite.to( baseNode, speed, {z: z, delay:delay, ease: Quart.easeInOut} );
		}
		
//		override protected function createSketchArea() : void
//		{
//			_sketchArea = new Pv3dSketchArea( currentContainer as ISketchable );
//		}
	}
}
