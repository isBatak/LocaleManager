package {

	import flash.events.IEventDispatcher;
	
	import controller.LanguageCommand;
	
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.api.LogLevel;
	
	import service.ILanguage;
	import service.LanguageService;
	
	import signals.notifications.NotifyLanguageErrorSignal;
	import signals.notifications.NotifyLanguageLoadedSignal;
	import signals.notifications.NotifyLanguageUpdateSignal;
	import signals.requests.RequestLanguageChangeSignal;
	import signals.requests.RequestLanguageLoadSignal;
	
	import view.contentview.ContentView;
	import view.contentview.ContentViewMediator;
	import view.homeview.HomeView;
	import view.homeview.HomeViewMediator;
	import view.mainmenuview.MainMenuView;
	import view.mainmenuview.MainMenuViewMediator;

	public class AppConfig implements IConfig
	{
		[Inject]
		public var context:IContext;

		[Inject]
		public var commandMap:ISignalCommandMap;

		[Inject]
		public var mediatorMap:IMediatorMap;

		[Inject]
		public var injector:IInjector;

		[Inject]
		public var logger:ILogger;

		[Inject]
		public var contextView:ContextView;

		[Inject]
		public var dispatcher:IEventDispatcher;

		public function configure():void 
		{
			// Configure logger.
			context.logLevel = LogLevel.DEBUG;
			logger.info( "configuring application" );

			// Map commands.
			commandMap.map( RequestLanguageLoadSignal ).toCommand( LanguageCommand ).withExecuteMethod("loadLanguage");
			commandMap.map( RequestLanguageChangeSignal ).toCommand( LanguageCommand ).withExecuteMethod("changeLanguage").withPayloadInjection(false);

			// Map independent notification signals.
			injector.map( NotifyLanguageLoadedSignal ).asSingleton();
			injector.map( NotifyLanguageUpdateSignal ).asSingleton();
			injector.map( NotifyLanguageErrorSignal ).asSingleton();

			// Map views.
			mediatorMap.map( ContentView ).toMediator( ContentViewMediator );
			mediatorMap.map( HomeView ).toMediator( HomeViewMediator );
			mediatorMap.map( MainMenuView ).toMediator( MainMenuViewMediator );
			
			// Map models.

			// Map services.
			injector.map( ILanguage ).toSingleton( LanguageService );
			
			// Start.
			context.afterInitializing(init);

		}

		private function init():void 
		{
			logger.info( "application ready" );
		}
	}
}