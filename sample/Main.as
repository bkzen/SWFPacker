package 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	/**
	 * ...
	 * @author jc at bk-zen.com
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			var loader: Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete); // なくてもよい
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(Event.COMPLETE, onSWFPackerComplete);
			loader.load(new URLRequest("materials.swf"), new LoaderContext(false, ApplicationDomain.currentDomain));
			//loader.load(new URLRequest("materials.swf"), new LoaderContext(false, loaderInfo.applicationDomain)); // またはこちら
		}
		
		// loader から Event.COMPLETE が送出されたら SWFPacker の準備が完了
		private function onSWFPackerComplete(e: Event): void 
		{
			ApplicationDomain.currentDomain.getDefinition("Hoge");
			//loaderInfo.applicationDomain.getDefinition("Hoge"); // またはこちら
		}
		
		private function onLoadComplete(e:Event):void 
		{
			
		}
		
		private function onIOError(e: IOErrorEvent): void 
		{
			
		}
		
	}
	
}