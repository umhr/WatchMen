package
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.lazyloaders.LazyXMLLoader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author umhr
	 */
	public class Main extends Sprite 
	{
		
		private var _lazyXMLLoader:LazyXMLLoader;
		static public var settingData:SettingData;
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			_lazyXMLLoader = new LazyXMLLoader("lazy.xml", 'one');
			_lazyXMLLoader.addEventListener(BulkLoader.COMPLETE, lazy_complete);
			_lazyXMLLoader.start();
		}
		
		private function lazy_complete(e:Event):void 
		{
			var settingXML:XML = _lazyXMLLoader.getXML("settingXML", true);
			
			settingData = new SettingData(settingXML);
			
			addChild(new Container());
		}
	}
	
}