package 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author umhr
	 */
	public class Container extends Sprite 
	{
		private var _tf:TextField;
		private var _erroeTF:TextField = new TextField();
		private var _startDate:Date = new Date();
		private var _count:int = 0;
		private var _documentsDirectory:File;
		private var _shape:Shape = new Shape();
		public function Container() 
		{
			init();
		}
		private function init():void 
		{
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}

		private function onInit(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			// entry point
			
			//trace("1日", 1000 * 60 * 60 * 24*1);
			//trace("24日20時間31分23秒647", 1000 * 60 * 60 * 24 * 24 + (1000 * 60 * 60) * 20 + (1000 * 60 ) * 31 + 1000 * 23 + 647);//2,147,483,647
			//trace("74日13時間34分10秒941", 1000 * 60 * 60 * 24 * 74 + (1000 * 60 * 60) * 13 + (1000 * 60 ) * 34 + 1000 * 10 + 941);//6,442,450,941
			//trace("74日13時間33分40秒000", 1000 * 60 * 60 * 24 * 74 + (1000 * 60 * 60) * 13 + (1000 * 60 ) * 33 + 1000 * 40 + 000);//6,442,420,000
			//trace(new Date(2016, 5, 25, 4, 20, 31), new Date(2016, 3, 11, 14, 46, 51));
			//trace(2147483647 * 3);
			//trace((2147483647 * 3)/(1000 * 60 * 60 * 24));
			//trace(new Date(2016, 5, 25, 4, 20, 31).time - new Date(2016, 3, 11, 14, 46, 51).time);
			//trace(2147483381 - 2147483647);
			//
			//var app11:Date = new Date(2016, 3, 11, 14, 46, 51);
			//app11.time+= 4294967295;
			//trace(app11);
			
			
			var path:String = "WatchMen";
			path += _startDate.fullYear;
			path += "_";
			path += String(_startDate.month + 101).substr(1);
			path += String(_startDate.date + 100).substr(1);
			path += "_";
			path += String(_startDate.hours + 100).substr(1);
			path += String(_startDate.minutes + 100).substr(1);
			path += ".txt";
			_documentsDirectory = File.documentsDirectory.resolvePath(path);
			
			_tf = new TextField();
			_tf.defaultTextFormat = new TextFormat("_sans", 24, 0x999999);
			_tf.width = 640;
			_tf.height = 210;
			addChild(_tf);
			
			_erroeTF = new TextField();
			_erroeTF.defaultTextFormat = new TextFormat("_sans", 24, 0xFF0000);
			_erroeTF.width = 640;
			_erroeTF.height = 210;
			addChild(_erroeTF);
			
			_shape.graphics.beginFill(0xFF0000);
			_shape.graphics.drawRect( -10, -10, 20, 20);
			_shape.graphics.endFill();
			_shape.x = stage.stageWidth - 20;
			_shape.y = 20;
			addChild(_shape);
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame(e:Event):void 
		{
			
			//if (_count % (30 * Main.settingData.interval) == 0) {
				//_count = 0;
			try{
				var text:String = "";
				text += "Start Date at : " + _startDate.toLocaleString() +" ." + _startDate.milliseconds;
				
				// getTimer()のままだと、intの正を超えた場合に負の数を示す。
				//text += "\n";
				//text += "getTimer : " + getTimer();
				//text += "\n";
				////text += "TimeGetTimeString : " + TimeGetTimeString(new Date().time-_startDate.time);
				//text += "TimeGetTimeString : " + TimeGetTimeString(getTimer());
				
				var duration:uint = getTimer();
				text += "\n";
				text += "getTimer(uint) : " + duration
				text += "\n";
				text += "TimeGetTimeString : " + TimeGetTimeString(duration);
				
				// ByteArrayに書き込んでuintで読む
				//var byteArray:ByteArray = new ByteArray();
				//byteArray.writeInt(getTimer());
				//byteArray.position = 0;
				//text += "\n";
				//text += "getTimer(uint) : " + byteArray.readUnsignedInt();
				//text += "\n";
				//byteArray.position = 0;
				//text += "TimeGetTimeString : " + TimeGetTimeString(byteArray.readUnsignedInt());
				
				text += "\n";
				text += "Latest Date at : " + new Date().toLocaleString() +" ." + new Date().milliseconds;
				
				text += "\n";
				text += "LatestDate-StartDate time : " + (new Date().time-_startDate.time);
				text += "\n";
				text += "TimeGetTimeString : " + TimeGetTimeString(new Date().time-_startDate.time);
				
				_tf.text = text;
			}catch (e:Error) {
				_erroeTF.text = e.errorID + e.name+e.message;
			}
			
			if (_count % (30*60) == 0) {
				var stream:FileStream = new FileStream();
				stream.open(_documentsDirectory, FileMode.WRITE);
				stream.writeUTFBytes(text);
				stream.close();
			}
			
			_shape.rotation ++;
			
			_count ++;
		}
		
		// http://hakuhin.jp/as3/date.html
		private function TimeGetTimeString(time:Number):String{

			var milli_sec:Number = time % 1000;
			time = (time - milli_sec) / 1000;
			var sec:Number = time % 60;
			time = (time - sec) / 60;
			var min:Number = time % 60;
			var hou:Number = (time - min) / 60;
			//hou %= 24;// 2016/02/26修正
			var day:Number = Math.floor(hou / 24);
			hou %= 24;
			
			// 文字列として連結
			return day + ":" + hou  + ":" +
				((min < 10) ? "0" : "") + min + ":" +
				((sec < 10) ? "0" : "") + sec + "." +
				((milli_sec < 100) ? "0" : "") + ((milli_sec < 10) ? "0" : "") + milli_sec;
		}
		
	}
	
}