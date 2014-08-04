package view.contentview
{
	import robotlegs.bender.framework.api.ILogger;
	
	import signals.notifications.NotifyLanguageErrorSignal;
	import signals.notifications.NotifyLanguageLoadedSignal;
	import signals.requests.RequestLanguageChangeSignal;
	import signals.requests.RequestLanguageLoadSignal;
	
	import view.base.MediatorBase;
	
	public class ContentViewMediator extends MediatorBase
	{
		[Inject]
		public var logger:ILogger;
		
		[Inject]
		public var view:ContentView;
		
		[Inject]
		public var requestLanguageLoadSignal:RequestLanguageLoadSignal;
		
		[Inject]
		public var requestLanguageChangedSignal:RequestLanguageChangeSignal;
		
		[Inject]
		public var notifyLanguageLoadedSignal:NotifyLanguageLoadedSignal;
		
		[Inject]
		public var notifyLanguageErrorSignal:NotifyLanguageErrorSignal;
		
		public function ContentViewMediator()
		{
			super();
		}
		
		override public function initialize():void {
			
			super.initialize();
			
			logger.info( "ContentViewMediator initialized" );

			// From app
			notifyLanguageLoadedSignal.add(onLanguageLoaded);
			notifyLanguageErrorSignal.add(onLanguageError);

			// From view
			view.languageChangedSignal.add(onLanguageChanged);
			view.loaderInitalizedSignal.add(onLoaderInit);

		}
		
		private function onLoaderInit():void
		{
			// Trigger language service.
			requestLanguageLoadSignal.dispatch();
		}
		
		/**
		 * This is triggered from the view to notify Service that language is changed.
		 */
		private function onLanguageChanged(locale:String):void
		{
			requestLanguageChangedSignal.dispatch(locale);
		}
		
		/**
		 * This is triggered from application on startup when service is done loading language files.
		 */
		private function onLanguageLoaded(message:String):void
		{
			logger.info(message);
			view.loaderOutput(message);
			// Animates the loader out and shows main content
			view.loadingOver();
		}
		
		private function onLanguageError(message:String):void
		{
			logger.info(message);
			view.errorOutput(message);
			view.resetLanguagePicker();
		}
	}
}