package view.homeview
{
	import robotlegs.bender.framework.api.ILogger;
	
	import view.base.MediatorBase;
	
	public class HomeViewMediator extends MediatorBase
	{
		[Inject]
		public var logger:ILogger;
		
		[Inject]
		public var view:HomeView;
		
		public function HomeViewMediator()
		{
			super();
		}
		
		override public function initialize():void 
		{
			super.initialize();
			
			logger.info( "HomeViewMediator initialized" );
			
		}
	}
}