package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.skins.IStyleProvider;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.textures.SubTexture;
	import starling.utils.deg2rad;
	
	public class ProgressSpinner extends FeathersControl
	{
		/**
		 * The default <code>IStyleProvider</code> for all <code>ProgressBar</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;
		
		public function ProgressSpinner()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return ProgressSpinner.globalStyleProvider;
		}
		
		/**
		 * @private
		 */
		protected var _originalSpinnerWidth:Number = NaN;
		
		/**
		 * @private
		 */
		protected var _originalSpinnerHeight:Number = NaN;
		
		/**
		 * @private
		 */
		protected var currentSpinner:DisplayObject;
		
		/**
		 * @private
		 */
		protected var _spinnerSkin:DisplayObject;
		
		/**
		 * @private
		 */
		protected var _spinnerContainer:Sprite;
		
		/**
		 * A spinner to display.
		 *
		 * <p>In the following example, the progress spinner is given a skin:</p>
		 *
		 * <listing version="3.0">
		 * spinner.spinnerSkin = new Image( texture );</listing>
		 *
		 * @default null
		 */
		public function get spinnerSkin():DisplayObject
		{
			return this._spinnerSkin;
		}
		
		/**
		 * @private
		 */
		public function set spinnerSkin(value:DisplayObject):void
		{
			if(this._spinnerSkin == value)
			{
				return;
			}
			this._spinnerSkin = value;
			if(this._spinnerSkin && this._spinnerSkin.parent != this)
			{
				this._spinnerSkin.visible = false;
				this._spinnerContainer = new Sprite();
				this._spinnerContainer.addChild(this._spinnerSkin);
				addChildAt(this._spinnerContainer, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		override protected function initialize():void
		{
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame():void
		{
			this._spinnerSkin.rotation += deg2rad(10);
		}
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			
			if(stylesInvalid || stateInvalid)
			{
				this.refreshSpinner();
			}
			
			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;
			
			if(sizeInvalid || stylesInvalid || stateInvalid)
			{
				if(this.currentSpinner)
				{
					this.currentSpinner.width = this.actualWidth;
					this.currentSpinner.height = this.actualHeight;
					
					this._spinnerContainer.width = this.actualWidth;
					this._spinnerContainer.height = this.actualHeight;
				}
			}
		}
		
		/**
		 * If the component's dimensions have not been set explicitly, it will
		 * measure its content and determine an ideal size for itself. If the
		 * <code>explicitWidth</code> or <code>explicitHeight</code> member
		 * variables are set, those value will be used without additional
		 * measurement. If one is set, but not the other, the dimension with the
		 * explicit value will not be measured, but the other non-explicit
		 * dimension will still need measurement.
		 *
		 * <p>Calls <code>setSizeInternal()</code> to set up the
		 * <code>actualWidth</code> and <code>actualHeight</code> member
		 * variables used for layout.</p>
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			var needsWidth:Boolean = this.explicitWidth != this.explicitWidth; //isNaN
			var needsHeight:Boolean = this.explicitHeight != this.explicitHeight; //isNaN
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			var newWidth:Number = needsWidth ? this._originalSpinnerWidth : this.explicitWidth;
			var newHeight:Number = needsHeight ? this._originalSpinnerHeight  : this.explicitHeight;
			return this.setSizeInternal(newWidth, newHeight, false);
		}
		
		/**
		 * @private
		 */
		protected function refreshSpinner():void
		{
			this.currentSpinner = this._spinnerSkin;
			
			if(this.currentSpinner)
			{
				if(this._originalSpinnerWidth != this._originalSpinnerWidth) //isNaN
				{
					this._originalSpinnerWidth = this.currentSpinner.width;
				}
				if(this._originalSpinnerHeight != this._originalSpinnerHeight) //isNaN
				{
					this._originalSpinnerHeight = this.currentSpinner.height;
				}
				this.currentSpinner.visible = true;
				
				this.currentSpinner.alignPivot();
				this.currentSpinner.x = this.currentSpinner.width * 0.5;
				this.currentSpinner.y = this.currentSpinner.height * 0.5;
			}
		}
		
		override public function dispose():void
		{
			_originalSpinnerWidth = NaN;
			_originalSpinnerHeight = NaN;
			currentSpinner.dispose();
			_spinnerSkin.dispose();
			_spinnerContainer.dispose();
			super.dispose();
		}
	}
}