package feathers.themes
{
	import feathers.controls.ProgressSpinner;
	import feathers.core.ModalManager;
	
	import starling.display.Image;
	import starling.textures.Texture;

	public class BaseMetalWorksMobileThemeExtended extends BaseMetalWorksMobileTheme
	{
		protected var spinnerSkinTextures:Texture;
		
		public function BaseMetalWorksMobileThemeExtended(scaleToDPI:Boolean=true)
		{
			super(scaleToDPI);
		}
		
		override protected function initializeTextures():void
		{
			super.initializeTextures();
			this.spinnerSkinTextures = this.atlas.getTexture("spinner-skin");
		}
		
		override protected function initializeStyleProviders():void
		{
			super.initializeStyleProviders();
			//progress spinner
			this.getStyleProviderForClass(ProgressSpinner).defaultStyleFunction = this.setProgressSpinnerStyles;
		}
		
		//-------------------------
		// ProgressSpinner
		//-------------------------
		
		protected function setProgressSpinnerStyles(progress:ProgressSpinner):void
		{
			var spinnerSkin:Image = new Image(this.spinnerSkinTextures);
			
			spinnerSkin.width = 60 * this.scale;
			spinnerSkin.height = 60 * this.scale;
			
			progress.spinnerSkin = spinnerSkin;
		}
	}
}