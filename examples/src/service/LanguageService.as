package service
{
	import events.LocaleManagerEvent;
	
	import robotlegs.bender.framework.api.ILogger;
	
	import signals.notifications.NotifyLanguageErrorSignal;
	import signals.notifications.NotifyLanguageLoadedSignal;
	import signals.notifications.NotifyLanguageUpdateSignal;

	public class LanguageService implements ILanguage
	{
		[Inject]
		public var logger:ILogger;
		
		[Inject]
		public var notifyLanguageLoadedSignal:NotifyLanguageLoadedSignal;
		
		[Inject]
		public var notifyLanguageUpdateSignal:NotifyLanguageUpdateSignal;
		
		[Inject]
		public var notifyLanguageErrorSignal:NotifyLanguageErrorSignal;
		
		private var _locales:LocaleManager;
		
		public function LanguageService()
		{
			this._locales = new LocaleManager();
			this._locales.verbose = true;
		}
		
		/**
		 * Init languages
		 */
		public function initialize():void
		{
			// Init Languages
			this._locales.addEventListener(LocaleManagerEvent.COMPLETE, onLoadComplete);
			this._locales.addEventListener(LocaleManagerEvent.UPDATE, onUpdateComplete);
			this._locales.addEventListener(LocaleManagerEvent.ERROR, onError);
			this._locales.load();
		}
		
		/**
		 * Update language
		 */
		public function updateLanguage(locale:String):void
		{
			this._locales.currentLang = locale;
		}
		
		protected function onLoadComplete(event:LocaleManagerEvent):void
		{
			logger.info(event.message);
			removeLoadListeners();
			notifyLanguageLoadedSignal.dispatch(event.message);
		}
		
		protected function onUpdateComplete(event:LocaleManagerEvent):void
		{
			logger.info(event.message);
			notifyLanguageUpdateSignal.dispatch(event.message);
		}
		
		protected function onError(event:LocaleManagerEvent):void
		{
			logger.info(event.message);
			removeLoadListeners();
			notifyLanguageErrorSignal.dispatch(event.message);
		}
		
		private function removeLoadListeners():void
		{
			this._locales.removeEventListener(LocaleManagerEvent.COMPLETE, onLoadComplete);
		}
	}
}


