package signals.notifications
{
	import org.osflash.signals.Signal;
	
	public class NotifyLanguageUpdateSignal extends Signal
	{
		public function NotifyLanguageUpdateSignal(...valueClasses)
		{
			super(String);
		}
	}
}