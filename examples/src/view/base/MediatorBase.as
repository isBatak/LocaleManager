package view.base
{
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	import signals.notifications.NotifyLanguageUpdateSignal;
	
	import view.interfaces.IObserver;
	
	public class MediatorBase extends StarlingMediator
	{
		[Inject]
		public var notifyLanguageUpdateSignal:NotifyLanguageUpdateSignal;
		
		public function MediatorBase()
		{
			super();
		}
		
		override public function initialize():void 
		{
			// From app
			notifyLanguageUpdateSignal.add(onLanguageUpdated);
		}
		
		/**
		 * This is triggered from application when the language is changed/updated.
		 */
		protected function onLanguageUpdated(message:String):void
		{
			if(viewComponent is IObserver){
				IObserver(this.viewComponent).updateLabels();
			}
		}
	}
}