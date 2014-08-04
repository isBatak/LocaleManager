package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;
	
	import mx.utils.StringUtil;
	
	import events.LocaleManagerEvent;

	/** LocaleManager provides basic localization support. It takes care of loading/parsing
	 *  resource bundle files (*.txt) and returns localized resources.
	 * 
	 *  <p>The localization files are stored in app://locale/[locale]/[locale].txt 
	 *  (ie.: app://locale/en_US/en_US.txt).
	 * 
	 *  <p>The content format for bundle files is <code>KEY = Value[Linebreak]</code>. 
	 *  <strong>You can use the = sign within the value, but not for keys or comments.</strong> 
	 *  
	 *  <p>Sample:<br/>
	 *  <code>
	 *  # Any line without "equals" char is a comment.<br/>
	 *  LABEL_FIRSTNAME = Firstname<br/>
	 *  LABEL_LASTNAME  = Lastname<br/>
	 *  </code> 
	 */
	public class LocaleManager extends EventDispatcher
	{
		private static var _instance:LocaleManager;

		private var _localeCollection:Object;
		private var _currentLang:String;
		private var _oldLang:String;
		
		private var _requiredBundlesReady:Boolean = false;
		
		/** The list of loaded and parsed key/value pairs. */
		private var localization:Dictionary;
		
		private var _verbose:Boolean = false;
		
		private var _useLinebreak:Boolean = true;
		
		private var _isUpdateOfCurrentLanguage:Boolean = false;
		
		public function LocaleManager()
		{
			_instance = this;
		}
		
		/** 
		 * Load languages.json file 
		 */
		public function load():void
		{
			internalLoad( "locale/languages.json", onLanguageListLoaded );
		}
		
		/** 
		 * Try to Parse JSON file and if succeed current language is set and proceed with loading of locale txt file.
		 */
		private function onLanguageListLoaded(event:Event):void
		{
			var fileStream:FileStream = event.target as FileStream;
			try{
				this._localeCollection = JSON.parse(fileStream.readUTFBytes(fileStream.bytesAvailable));
			}
			catch(e:Error)
			{
				log("Could not parse JSON file. " + e.toString());
				this.dispatchEvent(new LocaleManagerEvent(LocaleManagerEvent.ERROR, "Could not parse JSON file.\n" + e.toString()));
				return;
			}
			finally
			{
				fileStream.close();
			}
			
			this._currentLang = this._localeCollection[0].locale;
			
			this.internalLoad( "locale/" + this._currentLang + "/" + this._currentLang + ".txt", onLanguageFileLoaded );
		}
		
		/** Load current language txt file */
		private function internalLoad(url:String, onComplete:Function):void
		{
			// File reference pointing to app://locale/[locale]/[bundleName].txt 
			// (ie.: app://locale/en_US/localizedStrings.txt)
			var file:File = File.applicationDirectory.resolvePath( url );
			
			// if file not found
			if (!file.exists){
				this.resetLanguage();
				log("File " + url + " does not exist.");
				this.dispatchEvent(new LocaleManagerEvent(LocaleManagerEvent.ERROR, "File " + url + " does not exist."));
				return;
			}
			
			// try to open file stream (async)
			var fileStream:FileStream = new FileStream();
			fileStream.addEventListener(Event.COMPLETE, onComplete);
			try 
			{
				log("Loading resource " + url);
				fileStream.openAsync(file, FileMode.READ);
			}
			catch(e:Error) 
			{
				this.resetLanguage();
				log("Could not open FileStream. Error: " + e.toString());
				this.dispatchEvent(new LocaleManagerEvent(LocaleManagerEvent.ERROR, "Could not open FileStream. Error: " + e.toString()));
			}
		}
		
		/** Try to parse language file. */
		private function onLanguageFileLoaded(event:Event):void
		{
			var fileStream:FileStream = event.target as FileStream;
			try{
				parseLanguageFile(fileStream.readUTFBytes(fileStream.bytesAvailable));
			}
			catch(e:Error)
			{
				this.resetLanguage();
				log("Could not read/parse FileStream. Error: " + e.toString());
				this.dispatchEvent(new LocaleManagerEvent(LocaleManagerEvent.ERROR, "Could not read/parse FileStream. Error: " + e.toString()));
				return;
			}
			finally
			{
				fileStream.close();
			}
		}
		
		/** Parses the contents of a resource file (*.txt) */
		private function parseLanguageFile(content:String):void
		{
			localization = new Dictionary();
			
			// parsing the input line by line
			var lines:Array = content.split("\n");
			var length:uint = lines.length;
			var pair:Array;
			for (var i:int = 0; i < length; i++) 
			{
				pair = lines[i].split("=", 2);
				// ignore blank lines and comments (all lines without "=")
				if (pair.length < 2) continue;
				// parse line breaks in text
				if (_useLinebreak) pair[1] = pair[1].split("\\n").join("\n");
				// assign the key/value pair
				localization[StringUtil.trim(pair[0])] = StringUtil.trim(pair[1]);
			}
			
			if(this._isUpdateOfCurrentLanguage){
				this.dispatchEvent(new LocaleManagerEvent(LocaleManagerEvent.UPDATE, "Update of language file is completed!"));
			}
			this.dispatchEvent(new LocaleManagerEvent(LocaleManagerEvent.COMPLETE, "Loading and parsing of language file is completed!"));
		}
		
		/** <p>Returns the localized resource. 
		 *  <p>Sample for placeholders and parameters:<br/> 
		 *  <code>
		 *  USRMSG_UNLOCK = Congratulations {0}! You just unlocked {1}!
		 *  getString("USRMSG_UNLOCK", ["Superman", "super powers"]); 
		 *  // "Congratulations Superman! You just unlocked super powers!"
		 *  </code> */
		public function getString(resourceName:String, parameters:Array=null):String
		{
			if(resourceName in localization){
				var value:String = localization[resourceName];
				if (parameters)
					value = StringUtil.substitute(value, parameters);
				return value;
			}
			
			log("getString(" + resourceName + "): No matching resource found.");
			return "";
		}
		
		/** Checks if language is in localeChain */
		private function inLocaleCollection( locale:String ):Boolean{
			var itemIndex:int = -1;
			var itemCount:int = this._localeCollection.length;
			for(var i:int = 0; i < itemCount; i++){
				if(this._localeCollection[i].locale == locale){
					itemIndex++;
				}
			}
			return ( itemIndex < 0 ) ? false : true;
		}
		
		private function resetLanguage():void
		{
			this._currentLang = this._oldLang;
		}
		
		/*  === Helpers ===  */
		
		/** Logs output to the console if verbose is true. */
		private function log(msg:String):void
		{
			if (verbose)
				trace("[LocaleManager] " + msg);
		}
		
		
		/*  === Getter/Setter ===  */
		
		/** Instance of the LocaleManager singleton */
		public static function get instance():LocaleManager { return _instance ? _instance : null; }
		
		/** Locales Object that contains locale string (ie. "en_US") and locale label (ie. "EN") 
		 * <listing version="3.0">
		 * [
		 * 	{"label": "EN", "locale": "en_US" }
		 * ]
		 * </listing>
		 */
		public function get localeCollection():Object { return _localeCollection; }
		public function set localeCollection(value:Object):void { _localeCollection = value; }
		
		/** Current language in form of "xx_XX" */
		public function get currentLang():String { return _currentLang; }
		public function set currentLang(value:String):void {
			if (inLocaleCollection(value)){
				if(!_isUpdateOfCurrentLanguage){
					this._isUpdateOfCurrentLanguage = true; // To dispatch UPDATE event
				}
				// Save current language in case of error while loading new one, so it can be reset.
				this._oldLang = this._currentLang;
				this._currentLang = value;
				this.internalLoad( "locale/" + this._currentLang + "/" + this._currentLang + ".txt", onLanguageFileLoaded );
			}	
			else{
				throw new ArgumentError("Lang: " + value + "is not supported language");
			}
		}
		
		/** Indicates whether all required bundles are ready. 
		 *  <p>NOTE: Will return true if no required bundles have been added. */
		public function get requiredBundlesReady():Boolean { return _requiredBundlesReady; }
		
		/** If verbose is set true, output is logged to the console. */
		public function get verbose():Boolean { return _verbose; }
		public function set verbose(value:Boolean):void { _verbose = value; }

		/** If set true, "\n" will be parsed as linebreak. Default true. */
		public function get useLinebreak():Boolean { return _useLinebreak; }
		public function set useLinebreak(value:Boolean):void { _useLinebreak = value; }

	}
}