package view
{

	import feathers.controls.Drawers;
	import feathers.controls.ScreenNavigator;
	import feathers.motion.transitions.ScreenFadeTransitionManager;
	import feathers.themes.MetalWorksMobileTheme;
	import feathers.themes.StyleNameFunctionTheme;
	
	import view.contentview.ContentView;
	import view.enums.ViewEnum;

	public class StarlingRootSprite extends Drawers
	{
		private var _feathersTheme:StyleNameFunctionTheme;
		private var _navigator:ScreenNavigator;
		private var _transitionManager:ScreenFadeTransitionManager;
		private var _contentView:ContentView;
		
		private static const MAIN_MENU_EVENTS:Object =
			{
				showHome: ViewEnum.HOME,
				showMainMenu: ViewEnum.MAINMENU
			};

		public function StarlingRootSprite() 
		{
			super();
		}

		override protected function initialize():void {
			
			// Define application UI theme.
			_feathersTheme = new MetalWorksMobileTheme( stage );
			
			// Content View
			_contentView = new ContentView();
			this.content = _contentView;
		}
	}
}
