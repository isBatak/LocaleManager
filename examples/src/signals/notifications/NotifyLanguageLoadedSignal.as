package signals.notifications
{
	import org.osflash.signals.Signal;
	
	public class NotifyLanguageLoadedSignal extends Signal
	{
		public function NotifyLanguageLoadedSignal(...valueClasses)
		{
			super(String);
		}
	}
}