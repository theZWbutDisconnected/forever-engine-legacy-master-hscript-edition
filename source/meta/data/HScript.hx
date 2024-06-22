package meta.data;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.tile.FlxGraphicsShader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
// import flxanimate.FlxAnimate;
import gameObjects.Boyfriend;
import gameObjects.Character;
import gameObjects.Stage;
import gameObjects.background.*;
import gameObjects.userInterface.HealthIcon;
import gameObjects.userInterface.notes.Note;
import gameObjects.userInterface.notes.Strumline;
import haxe.ds.StringMap;
import hscript.Expr;
import hscript.Interp;
import hscript.Parser;
import lime.app.Application;
import lime.app.Application;
import lime.graphics.Image;
import lime.graphics.RenderContext;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.MouseButton;
import lime.ui.Window;
import meta.data.dependency.FNFSprite;
import meta.data.dependency.RealColor;
import meta.state.PlayState;
import openfl.display.GraphicsShader;
import openfl.display.Shader;
import openfl.display.Sprite;
import openfl.filters.ShaderFilter;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.utils.Assets as OpenFlAssets;
import openfl.utils.Assets;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

using StringTools;
#if lime
import lime.app.Application as LimeApplication;
import lime.ui.WindowAttributes;
#end



class HScript
{
	var interp:Interp = new Interp();

	var parser:Parser = new Parser();

	public function new()
	{
		// Classes (Haxe)
		interp.variables.set("Sys", Sys);
		interp.variables.set("Std", Std);
		interp.variables.set("Math", Math);
		interp.variables.set("StringTools", StringTools);
		interp.variables.set("FileSystem", FileSystem);
		interp.variables.set("Lib", openfl.Lib);
		interp.variables.set("Application", Application);
		interp.variables.set("Assets", Assets);

		// Classes (Flixel)
		interp.variables.set("FlxG", FlxG);
		interp.variables.set("FlxSprite", FlxSprite);
		//interp.variables.set("FlxAnimate", FlxAnimate);
		interp.variables.set("FlxCamera", FlxCamera);
		interp.variables.set("FlxMath", FlxMath);
		interp.variables.set("FlxPoint", FlxPoint);
		interp.variables.set("FlxRect", FlxRect);
		interp.variables.set("FlxTween", FlxTween);
		interp.variables.set("FlxTimer", FlxTimer);
		interp.variables.set("FlxEase", FlxEase);
		interp.variables.set("FlxAtlasFrames", FlxAtlasFrames);
		interp.variables.set("Shader", Shader);
		interp.variables.set("ShaderFilter", ShaderFilter);
		interp.variables.set("GraphicsShader", GraphicsShader);
		interp.variables.set("FlxGraphicsShader", FlxGraphicsShader);
		interp.variables.set("FlxColor", RealColor); // lol
		interp.variables.set("FlxGroup", FlxGroup);
		interp.variables.set("FlxGraphic", FlxGraphic);
		interp.variables.set("FlxTransWindow", flixel.FlxTransWindow);

		// Classes (Forever)
		interp.variables.set("Init", Init);
		interp.variables.set("Paths", Paths);
		interp.variables.set("Note", Note);
		interp.variables.set("Strumline", Strumline);
		interp.variables.set("Conductor", Conductor);
		interp.variables.set("UIStaticArrow", UIStaticArrow);
		interp.variables.set("Character", Character.instance);
		interp.variables.set("BackgroundGirls", BackgroundGirls);
		interp.variables.set("BackgroundDancer", BackgroundDancer);
		interp.variables.set("Boyfriend", Boyfriend);
		interp.variables.set("FNFSprite", FNFSprite);
		interp.variables.set("HealthIcon", HealthIcon);
		interp.variables.set("PlayState", PlayState);
		interp.variables.set("Stage", Stage.instance);
		interp.variables.set("Game", PlayState.instance);
		interp.variables.set("File", File);

		interp.variables.set("trace", LogUtils.log);

		parser.allowTypes = true;
		parser.allowJSON = true;
		parser.allowMetadata = true;
	}

	public function loadModule(path:String, ?params:StringMap<Dynamic>) {
		// interp.expr(parser.parseString(code));
		if (params != null)
		{
	    	for (i in params.keys())
	    	{
	    		interp.variables.set(i, params.get(i));
	    	}
	    }

		// importing!!

		interp.variables.set("import", function(className:String)
		{
			// importClass("flixel.util.FlxSort") should give you FlxSort.byValues, etc
			// i would LIKE to do like.. flixel.util.* but idk if I can get everything in a namespace
			var classSplit:Array<String> = className.split(".");
			var daClassName = classSplit[classSplit.length - 1]; // last one
			if (daClassName == '*')
			{
				var daClass = Type.resolveClass(className);
				while (classSplit.length > 0 && daClass == null)
				{
					daClassName = classSplit.pop();
					daClass = Type.resolveClass(classSplit.join("."));
					if (daClass != null)
						break;
				}
				if (daClass != null)
				{
					for (field in Reflect.fields(daClass))
					{
						interp.variables.set(field, Reflect.field(daClass, field));
					}
				}
				else
				{
					FlxG.log.error('Could not import class ${daClass}');
					trace('Could not import class ${daClass}');
				}
			}
			else
			{
				var daClass = Type.resolveClass(className);
				if (daClass == null)
				{
					FlxG.log.error('Could not import class ${daClass}');
					trace('Could not import class ${daClass}');
					return;
				}
				interp.variables.set(daClassName, daClass);
			}
		});
		interp.execute(parser.parseString(File.getContent(path),path));
	}

	public function get(field:String):Dynamic {
		if (exists(field)) {return interp.variables.get(field);}
		return {};
	}

	public function set(field:String, value:Dynamic) {
		if (exists(field)) {return interp.variables.set(field, value);}
		return {};
	}

	public function exists(field:String):Bool
		return interp.variables.exists(field);
}