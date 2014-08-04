package events
{
	import flash.events.Event;

	public class LocaleManagerEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		public static var UPDATE:String = "update";
		public static const ERROR:String = "error";
		
		private var _message:String;
		
		public function LocaleManagerEvent(type:String, message:String, bubbles:Boolean=false, cancelable:Boolean=true)
		{
			this._message = message;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new LocaleManagerEvent(type, message, bubbles, cancelable);
		}
		
		override public function toString():String {
			return formatToString("LocaleManagerEvent", "type", "message");
		}

		public function get message():String
		{
			return _message;
		}

	}
}