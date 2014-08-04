package view.mainmenuview
{
	import robotlegs.bender.framework.api.ILogger;
	
	import view.base.MediatorBase;
	
	public class MainMenuViewMediator extends MediatorBase
	{
		[Inject]
		public var logger:ILogger;
		
		[Inject]
		public var view:MainMenuView;
		
		public function MainMenuViewMediator()
		{
			super();
		}
		
		override public function initialize():void 
		{
			super.initialize();
			
			logger.info( "MainMenuViewMediator initialized" );
			
		}
	}
}