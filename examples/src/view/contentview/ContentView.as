package view.contentview
{
	import feathers.controls.Alert;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.PickerList;
	import feathers.controls.ProgressSpinner;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	
	import org.osflash.signals.Signal;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	import view.enums.ViewEnum;
	import view.homeview.HomeView;
	import view.interfaces.IObserver;
	import view.mainmenuview.MainMenuView;
	
	public class ContentView extends LayoutGroup implements IObserver
	{
		private var _header:Header;
		private var _navigator:ScreenNavigator;
		private var _transitionManager:ScreenSlidingStackTransitionManager;
		private var _spinner:ProgressSpinner;
		private var _loaderLabel:Label;
		private var _languagePickerList:PickerList;
		
		public var loaderInitalizedSignal:Signal;
		public var languageChangedSignal:Signal;

		public function ContentView()
		{
			super();
			
			this.loaderInitalizedSignal = new Signal();
			this.languageChangedSignal = new Signal(String);
		}

		override protected function initialize():void
		{
			super.initialize();

			setLoader();
			loaderOutput("1. test test");
			/* To be sure that loader is created because error can 
			occur before feathers initialize method is called */
			loaderInitalizedSignal.dispatch();
			loaderOutput("2. test test");
		}
		
		/**
		 * Creates a loader.
		 */
		private function setLoader():void
		{
			// spinner
			this._spinner = new ProgressSpinner();
			addChild(this._spinner);
			
			// textfield
			this._loaderLabel = new Label();
			
			addChild(this._loaderLabel);
			
			// preLayout
			var layout:AnchorLayout = new AnchorLayout();
			this.layout = layout;
			
			var spinnerlayoutData:AnchorLayoutData = new AnchorLayoutData();
			spinnerlayoutData.horizontalCenter = 0;
			spinnerlayoutData.verticalCenter = 0; 
			this._spinner.layoutData = spinnerlayoutData;
			
			var loaderLabellayoutData:AnchorLayoutData = new AnchorLayoutData();
			loaderLabellayoutData.bottom = 50;
			loaderLabellayoutData.left = 100; 
			loaderLabellayoutData.right = 100; 
			loaderLabellayoutData.top = 10;
			loaderLabellayoutData.topAnchorDisplayObject = this._spinner;
			this._loaderLabel.layoutData = loaderLabellayoutData;
		}
		
		public function loadingOver():void
		{
			Starling.juggler.tween(this._spinner,0.5, {
				alpha:0
			});
			Starling.juggler.tween(this._loaderLabel,0.5, {
				alpha:0,
				onComplete: function():void { 
					init();
				}
			});
		}
		
		/** Output message under the loader */
		public function loaderOutput(message:String):void
		{
			this._loaderLabel.text += message + "\n\n";
		}
		
		/**
		 * Preview the error on the screen. If the error occurred, while app is loading, 
		 * it will be displayed under the loader spinner, otherwise modal will be created 
		 * with proper message and confirmation button.
		 */
		public function errorOutput(message:String):void
		{
			if(this._loaderLabel){
				loaderOutput(message);
			}
			else{
				showAlert(message);
			}
		}
		
		/**
		 * Real initialize after data from server was retreaved.
		 * Main UI elements are added to stage and animated. 
		 */
		public function init():void{
			
			// remove loader elements
			this._loaderLabel.removeFromParent(true);
			this._loaderLabel = null;
			this._spinner.removeFromParent(true);
			this._spinner = null;
			
			// Header
			this._header = new Header();
			this._header.alpha = 0;
			this.addChild(this._header);
			
			// ScreenNavigator
			this._navigator = new ScreenNavigator();
			this._navigator.alpha = 0;
			this.addChild(this._navigator);
			
			this._navigator.clipContent = true;
			
			this._navigator.addScreen(ViewEnum.HOME, new ScreenNavigatorItem(HomeView));
			this._navigator.addScreen(ViewEnum.MAINMENU, new ScreenNavigatorItem(MainMenuView));
			
			// TransitionManager
			this._transitionManager = new ScreenSlidingStackTransitionManager(this._navigator);
			this._transitionManager.duration = 0.4;
			
			// Show Home
			this._navigator.showScreen(ViewEnum.HOME);
			
			// Language Picker List
			_languagePickerList = new PickerList();
			var languageList:ListCollection = new ListCollection( LocaleManager.instance.localeCollection );
			_languagePickerList.dataProvider = languageList;
			_languagePickerList.addEventListener(Event.CHANGE, changeLanguage);
			
			// Header Right Items
			this._header.rightItems = new <DisplayObject>[_languagePickerList];

			updateLabels();
			
			// layout
			setLayout();
			
			inAnimation();
		}
		
		private function inAnimation():void
		{
			Starling.juggler.tween(this._header ,0.5, {
				alpha:1
			});
			Starling.juggler.tween(this._navigator,0.5, {
				alpha:1
			});
		}
		
		private function setLayout():void
		{
			// Setting layout for this container
			var layout:AnchorLayout = new AnchorLayout();
			this.layout = layout;
			
			var headerLayoutData:AnchorLayoutData = new AnchorLayoutData();
			headerLayoutData.left = headerLayoutData.top = headerLayoutData.right = 0;
			this._header.layoutData = headerLayoutData;
			
			var navigatorlayoutData:AnchorLayoutData = new AnchorLayoutData();
			navigatorlayoutData.left = navigatorlayoutData.top = navigatorlayoutData.right = navigatorlayoutData.bottom = 0;
			navigatorlayoutData.topAnchorDisplayObject = this._header;
			this._navigator.layoutData = navigatorlayoutData;
		}
		
		private function showAlert(message:String):void
		{
			
			var alert:Alert = Alert.show( message, "Warning", new ListCollection(
				[
					{ label: "OK", triggered: okButton_triggeredHandler }
				]) );
		}
		
		private function okButton_triggeredHandler():void
		{
			// TODO
		}
		
		private function changeLanguage(event:Event):void
		{
			var target:PickerList = event.target as PickerList;
			languageChangedSignal.dispatch(target.selectedItem.locale);
		}
		
		/**
		 * Reset the language picker to old language in case of error.
		 */
		public function resetLanguagePicker():void
		{
			var count:int = _languagePickerList.dataProvider.length;
			for(var i:int = 0; i < count; i++){
				if(this._languagePickerList.dataProvider.data[i].locale == LocaleManager.instance.currentLang){					
					this._languagePickerList.selectedItem = _languagePickerList.dataProvider.data[i];
				}
			}
		}
		
		public function updateLabels():void
		{
			this._header.title = LocaleManager.instance.getString("CONTENT_VIEW");
		}
		
		/** Access to main TransitionManager instance */
		public function get transitionManager():ScreenSlidingStackTransitionManager { return _transitionManager; }
		public function set transitionManager(value:ScreenSlidingStackTransitionManager):void { _transitionManager = value; }
		
		/** Access to main ScreenNavigator instance */
		public function get navigator():ScreenNavigator { return _navigator; }
		public function set navigator(value:ScreenNavigator):void { _navigator = value; }
	}
}