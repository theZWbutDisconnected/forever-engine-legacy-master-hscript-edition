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
import flixel.util.RealColor;
// import flxanimate.FlxAnimate;
import gameObjects.Boyfriend;
import gameObjects.Character;
import gameObjects.Stage;
import gameObjects.background.*;
import gameObjects.userInterface.HealthIcon;
import gameObjects.userInterface.notes.Note;
import gameObjects.userInterface.notes.Strumline;
import haxe.Exception;
import haxe.Log;
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
		interp.variables.set("FlxColor", RealColor);
		interp.variables.set("trace", Log.trace);

		parser.allowTypes = true;
		parser.allowJSON = true;
		parser.allowMetadata = true;
	}

	public function loadModule(path:String, ?params:StringMap<Dynamic>)
	{
		// interp.expr(parser.parseString(code));
		if (params != null)
		{
			for (i in params.keys())
			{
				interp.variables.set(i, params.get(i));
			}
		}

		var handlerMethods = File.getContent(path);
		// handlerMethods = Preprocessor.preprocess(handlerMethods);

		// importing!!
		var imports = extractImports(handlerMethods);
		var classes:Array<String> = [];
		if (imports != null)
		{
			for (importLine in imports)
			{
				var moduleName = getModuleName(importLine);
				classes.push(moduleName);
				importClass(moduleName);
				handlerMethods = handlerMethods.replace(importLine, "");
			}
			trace("Import Classes: " + classes);
		}
		trace('[Script] ' + handlerMethods);
		interp.execute(parser.parseString(handlerMethods, path));
	}

	function extractImports(script:String):Array<String>
	{
		var importLines = [];
		var lines = script.split("\n");
		for (line in lines)
		{
			if (line.trim().startsWith("import"))
			{
				var s = line.trim();
				importLines.push(s + check(s));
			}
		}
		return importLines;
	}

	function check(v:String):String
	{
		if (!v.endsWith(';'))
		{
			FlxG.log.warn('Missing ;');
			throw("Missing ;");
			return ';';
		}
		return '';
	}

	function getModuleName(importLine:String):String
	{
		return importLine.replace("import ", "").replace(";", "");
	}

	function importClass(className:String)
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
				trace('Could not import class ${daClass}');
			}
		}
		else
		{
			var daClass = Type.resolveClass(className);
			if (daClass == null)
			{
				trace('Could not import class ${daClass}');
				return;
			}
			interp.variables.set(daClassName, daClass);
		}
	}

	public function get(field:String):Dynamic
	{
		if (exists(field))
		{
			return interp.variables.get(field);
		}
		return {};
	}

	public function set(field:String, value:Dynamic)
	{
		if (exists(field))
		{
			return interp.variables.set(field, value);
		}
		return {};
	}

	public function exists(field:String):Bool
		return interp.variables.exists(field);
}
/*
	class GenericInterp extends Interp {
	public function new() {
		super();
	}

	override public function cnew(cl:String, args:Array<Dynamic>):Dynamic {
		// Check if class is defined as generic in our context
		if (cl.indexOf("_") != -1) {
			var parts = cl.split("_");
			var baseClass = parts[0];
			var genericType = parts[1];

			switch (baseClass) {
				case "FlxTypedGroup":
					var genericClass:Dynamic = Type.resolveClass(genericType);
					if (genericClass == null) {
						genericClass = variables.get(genericType);
						if (genericClass == null) throw "Unknown generic type: " + genericType;
					}

					return new FlxTypedGroup<Dynamic>();
				default:
					throw "Unsupported generic base class: " + baseClass;
			}
		} else {
			return super.cnew(cl, args);
		}
		return null;
	}
	}

	class Preprocessor {
	public static function preprocess(script:String):String {
		var regex = ~/new\s+(\w+)<(\w+)>/;
		return regex.replace(script, 'new $1_$2()');
	}
}*/
