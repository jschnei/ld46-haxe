package;


import haxe.io.Bytes;
import lime.utils.AssetBundle;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {


	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;


	public static function init (config:Dynamic):Void {

		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();

		rootPath = null;

		if (config != null && Reflect.hasField (config, "rootPath")) {

			rootPath = Reflect.field (config, "rootPath");

		}

		if (rootPath == null) {

			#if (ios || tvos || emscripten)
			rootPath = "assets/";
			#elseif android
			rootPath = "";
			#elseif console
			rootPath = lime.system.System.applicationDirectory;
			#else
			rootPath = "./";
			#end

		}

		#if (openfl && !flash && !display)
		openfl.text.Font.registerFont (__ASSET__OPENFL__assets_data_action_man_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_monsterrat_ttf);
		
		#end

		var data, manifest, library, bundle;

		#if kha

		null
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("null", library);

		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("null");

		#else

		data = '{"name":null,"assets":"aoy4:pathy27:assets%2Fdata%2Fenable1.txty4:sizei1743367y4:typey4:TEXTy2:idR1y7:preloadtgoR0y25:assets%2Fdata%2Fukacd.txtR2i1936592R3R4R5R7R6tgoR2i49408R3y4:FONTy9:classNamey35:__ASSET__assets_data_action_man_ttfR5y30:assets%2Fdata%2FAction_Man.ttfR6tgoR0y34:assets%2Fdata%2Fdata-goes-here.txtR2zR3R4R5R12R6tgoR2i5148R3y5:SOUNDR5y30:assets%2Fsounds%2Funselect.wavy9:pathGroupaR14hR6tgoR2i4910R3R13R5y28:assets%2Fsounds%2Fselect.oggR15aR16y28:assets%2Fsounds%2Fselect.wavhR6tgoR0y36:assets%2Fsounds%2Fsounds-go-here.txtR2zR3R4R5R18R6tgoR2i10188R3R13R5R17R15aR16R17hgoR2i37918R3R13R5y27:assets%2Fsounds%2Fclear.wavR15aR19hR6tgoR2i10188R3R13R5y29:assets%2Fsounds%2Fbadword.wavR15aR20hR6tgoR0y36:assets%2Fmusic%2Fmusic-goes-here.txtR2zR3R4R5R21R6tgoR2i39706R3y5:MUSICR5y28:flixel%2Fsounds%2Fflixel.mp3R15aR23y28:flixel%2Fsounds%2Fflixel.ogghR6tgoR2i2114R3R22R5y26:flixel%2Fsounds%2Fbeep.mp3R15aR25y26:flixel%2Fsounds%2Fbeep.ogghR6tgoR2i33629R3R13R5R24R15aR23R24hgoR2i5794R3R13R5R26R15aR25R26hgoR2i15744R3R8R9y35:__ASSET__flixel_fonts_nokiafc22_ttfR5y30:flixel%2Ffonts%2Fnokiafc22.ttfR6tgoR2i29724R3R8R9y36:__ASSET__flixel_fonts_monsterrat_ttfR5y31:flixel%2Ffonts%2Fmonsterrat.ttfR6tgoR0y33:flixel%2Fimages%2Fui%2Fbutton.pngR2i519R3y5:IMAGER5R31R6tgoR0y36:flixel%2Fimages%2Flogo%2Fdefault.pngR2i3280R3R32R5R33R6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("default", library);
		

		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		

		#end

	}


}


#if kha

null

#else

#if !display
#if flash

@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_enable1_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_ukacd_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_action_man_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_data_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_unselect_wav extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_select_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_select_wav extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_clear_wav extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_badword_wav extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:keep @:file("assets/data/enable1.txt") @:noCompletion #if display private #end class __ASSET__assets_data_enable1_txt extends haxe.io.Bytes {}
@:keep @:file("assets/data/ukacd.txt") @:noCompletion #if display private #end class __ASSET__assets_data_ukacd_txt extends haxe.io.Bytes {}
@:keep @:font("export/html5/obj/webfont/Action_Man.ttf") @:noCompletion #if display private #end class __ASSET__assets_data_action_man_ttf extends lime.text.Font {}
@:keep @:file("assets/data/data-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_data_data_goes_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/unselect.wav") @:noCompletion #if display private #end class __ASSET__assets_sounds_unselect_wav extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/select.ogg") @:noCompletion #if display private #end class __ASSET__assets_sounds_select_ogg extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/sounds-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/select.wav") @:noCompletion #if display private #end class __ASSET__assets_sounds_select_wav extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/clear.wav") @:noCompletion #if display private #end class __ASSET__assets_sounds_clear_wav extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/badword.wav") @:noCompletion #if display private #end class __ASSET__assets_sounds_badword_wav extends haxe.io.Bytes {}
@:keep @:file("assets/music/music-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends haxe.io.Bytes {}
@:keep @:file("/home/jon/haxelib/flixel/4,7,0/assets/sounds/flixel.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends haxe.io.Bytes {}
@:keep @:file("/home/jon/haxelib/flixel/4,7,0/assets/sounds/beep.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends haxe.io.Bytes {}
@:keep @:file("/home/jon/haxelib/flixel/4,7,0/assets/sounds/flixel.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends haxe.io.Bytes {}
@:keep @:file("/home/jon/haxelib/flixel/4,7,0/assets/sounds/beep.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends haxe.io.Bytes {}
@:keep @:font("export/html5/obj/webfont/nokiafc22.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font {}
@:keep @:font("export/html5/obj/webfont/monsterrat.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font {}
@:keep @:image("/home/jon/haxelib/flixel/4,7,0/assets/images/ui/button.png") @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends lime.graphics.Image {}
@:keep @:image("/home/jon/haxelib/flixel/4,7,0/assets/images/logo/default.png") @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends lime.graphics.Image {}
@:keep @:file("") @:noCompletion #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else

@:keep @:expose('__ASSET__assets_data_action_man_ttf') @:noCompletion #if display private #end class __ASSET__assets_data_action_man_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "assets/data/Action_Man"; #else ascender = 1353; descender = -323; height = 1676; numGlyphs = 201; underlinePosition = -143; underlineThickness = 20; unitsPerEM = 2048; #end name = "Action Man"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/nokiafc22"; #else ascender = 2048; descender = -512; height = 2816; numGlyphs = 172; underlinePosition = -640; underlineThickness = 256; unitsPerEM = 2048; #end name = "Nokia Cellphone FC Small"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/monsterrat"; #else ascender = 968; descender = -251; height = 1219; numGlyphs = 263; underlinePosition = -150; underlineThickness = 50; unitsPerEM = 1000; #end name = "Monsterrat"; super (); }}


#end

#if (openfl && !flash)

#if html5
@:keep @:expose('__ASSET__OPENFL__assets_data_action_man_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_data_action_man_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_data_action_man_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#else
@:keep @:expose('__ASSET__OPENFL__assets_data_action_man_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_data_action_man_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_data_action_man_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#end

#end
#end

#end
