package signals.requests
{
	import org.osflash.signals.Signal;
	
	public class RequestLanguageChangeSignal extends Signal
	{
		public function RequestLanguageChangeSignal()
		{
			super(String);
		}
	}
}