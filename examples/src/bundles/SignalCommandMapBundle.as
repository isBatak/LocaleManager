package bundles
{

	import robotlegs.bender.extensions.signalCommandMap.SignalCommandMapExtension;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;

	public class SignalCommandMapBundle implements IExtension
	{
		public function extend( context:IContext ):void {
			context.install( SignalCommandMapExtension );
		}
	}
}
