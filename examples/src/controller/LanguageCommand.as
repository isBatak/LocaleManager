package controller
{
	
	import robotlegs.bender.framework.api.ILogger;
	
	import service.ILanguage;

	public class LanguageCommand
	{
		[Inject]
		public var languageService:ILanguage;
		
		[Inject]
		public var logger:ILogger;
		
		public function loadLanguage():void 
		{
			logger.info( "triggering language initial load service" );
			languageService.initialize();
		}
		
		public function changeLanguage(locale:String):void 
		{
			logger.info( "triggering language update with parameter " + locale );
			languageService.updateLanguage(locale);
		}
	}
}