package com.bkzen.utils 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Embed した SWF の準備が完了したら送出されます。
	 * イベントバブリングを使って Loader に Event.COMPLETE を送出します。
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * 素材 SWF をまとめるクラス
	 * 使い方はこのクラスを継承して Embed して SWF を作るだけ。
	 * Embed するクラスは public で定義すると自動で登録されます。
	 * @example 例
	 * <listing version="3.0">
	 * public class Materials extends SWFPacker
	 * {
	 *	[Embed(source = "/../assets/mat1.swf")]
	 *	public const Mat1: Class;
	 *	[Embed(source = "/../assets/mat2.swf")]
	 *	public var Mat2: Class;
	 *	[Embed(source = "/../assets/mat3.swf")]
	 *	public static const Mat3: Class;
	 *	[Embed(source = "/../assets/mat4.swf")]
	 *	public static const Mat4: Class;
	 * 	
	 * 	// public 以外 で定義する場合はコンストラクタ内で addClass() を呼ぶ
	 *	[Embed(source = "/../assets/mat5.swf")]
	 *	private const Mat5: Class;
	 * 
	 *	public function Materials() 
	 *	{
	 *		addClass(Mat5);
	 *	}
	 *	
	 * }
	 * // SWFPacker を使った SWF を読み込む。
	 * 	var loader: Loader = new Loader();
	 *	loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete); // なくてもよい
	 *	loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
	 *	loader.addEventListener(Event.COMPLETE, onSWFPackerComplete);
	 *	loader.load(new URLRequest("materials.swf"), new LoaderContext(false, ApplicationDomain.currentDomain));
	 *	//loader.load(new URLRequest("materials.swf"), new LoaderContext(false, loaderInfo.applicationDomain)); // またはこちら
	 * 
	 * // loader から Event.COMPLETE が送出されたら SWFPacker の準備が完了
	 * private function onSWFPackerComplete(e: Event): void 
	 * {
	 * 	ApplicationDomain.currentDomain.getDefinition("Hoge");
	 * 	//loaderInfo.applicationDomain.getDefinition("Hoge"); // またはこちら
	 * }
	 * </listing>
	 * @author jc at bk-zen.com
	 */
	public class SWFPacker extends Sprite 
	{
		private static const CLASS_NAME_FOOTER: String = "_dataClass";
		
		private var _classes: Array = [];
		private var _loaders: Array = [];
		private var _numInitializedClasses: int;
		private var _numClasses: int;
		private var thisName: String;
		
		public function SWFPacker() 
		{
			thisName = getQualifiedClassName(this).replace("::", ".");
			addEventListener(Event.ENTER_FRAME, init);
		}
		
		/**
		 * どうしても public 以外で定義したいクラスがあった場合に手動で登録する。
		 * @param	klass
		 */
		protected function addClass(klass: Class): void
		{
			// TODO private チェック
			var k: Class;
			try 
			{
				k = getDefinitionByName(getQualifiedClassName(klass).replace("::", ".") + CLASS_NAME_FOOTER) as Class;
				if (_classes.indexOf(k) < 0) 
				{
					_classes[_numClasses++] = k;
				}
			}
			catch (err: Error) { }
		}
		
		private function init(e: Event): void 
		{
			removeEventListener(Event.ENTER_FRAME, init);
			//
			var klass: Class, xml: XML, list: XMLList;
			xml = describeType(this["constructor"]);
			list = xml.children().(name() == "constant" || name() == "variable").@name;
			var i: uint, n: uint = list.length();
			for (i = 0; i < n; i++) 
			{
				try 
				{
					klass = getDefinitionByName(thisName + "_" + list[i] + CLASS_NAME_FOOTER) as Class;
					if (klass && (_classes.indexOf(klass) < 0)) 
						_classes[_numClasses++] = klass;
				}
				catch (err: Error) { }
			}
			list = xml.factory.children().(name() == "constant" || name() == "variable").@name;
			n = list.length();
			for (i = 0; i < n; i++) 
			{
				try 
				{
					klass = getDefinitionByName(thisName + "_" + list[i] + CLASS_NAME_FOOTER) as Class;
					if (klass && (_classes.indexOf(klass) < 0)) 
						_classes[_numClasses++] = klass;
				}
				catch (err: Error) { }
			}
			n = _numClasses;
			var loader: Loader;
			for (i = 0; i < n; i++) 
			{
				_loaders[i] = loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComp);
				loader.loadBytes(new _classes[i], new LoaderContext(false, ApplicationDomain.currentDomain));
			}
		}
		
		private function onComp(e: Event): void 
		{
			e.target.removeEventListener(Event.COMPLETE, onComp);
			if (++_numInitializedClasses == _numClasses)
			{
				trace("comp : " + _numClasses);
				_classes.length = 0;
				dispatchEvent(new Event(Event.COMPLETE, true));
			}
		}
		
	}

}