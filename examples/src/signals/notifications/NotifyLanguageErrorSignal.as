package signals.notifications
{
	import org.osflash.signals.Signal;
	
	public class NotifyLanguageErrorSignal extends Signal
	{
		public function NotifyLanguageErrorSignal(...valueClasses)
		{
			super(String);
		}
	}
}