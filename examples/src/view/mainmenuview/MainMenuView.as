package view.mainmenuview
{
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;
	
	import utils.locale.LocaleManager;
	
	import view.enums.ViewEnum;
	import view.interfaces.IObserver;
	
	public class MainMenuView extends Screen implements IObserver
	{

		private var label:Label;
		private var button:Button;
		
		public function MainMenuView()
		{
			super();
		}
		
		override protected function initialize():void{
			
			super.initialize();
			
			var vLayout:VerticalLayout = new VerticalLayout();
			vLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			vLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			this.layout = vLayout;
			
			label = new Label();
			addChild(label);
			
			button = new Button();
			button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
			addChild( button );
			
			updateLabels();
		}
		
		private function button_triggeredHandler( event:Event ):void
		{
			this.owner.showScreen( ViewEnum.HOME );
		}
		
		public function updateLabels():void
		{
			label.text = LocaleManager.instance.getString("MAIN_MENU_VIEW");
			button.label = LocaleManager.instance.getString("GO_TO_HOME");
		}
		
	}
}