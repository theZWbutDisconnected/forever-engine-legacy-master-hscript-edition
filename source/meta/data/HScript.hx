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
		interp.variables.set("Image", Image);
		interp.variables.set("FileSystem", FileSystem);
		interp.variables.set("Lib", openfl.Lib);
		interp.variables.set("Window", Window);
		interp.variables.set("Application", Application);
		interp.variables.set("Matrix", Matrix);
		interp.variables.set("Rectangle", Rectangle);
		interp.variables.set("Sprite", Sprite);
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

		parser.allowTypes = true;
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
		interp.execute(parser.parseString(File.getContent(path),path));
	}

	//from Hypno's Lullaby v2 source code
	
	/**
		* [Returns a field from the module]
			 * @param field 
			 * @return Dynamic
		return interp.variables.get(field)
	 */
	public function get(field:String):Dynamic
		return interp.variables.get(field);

	/**
	 * [Sets a field within the module to a new value]
	 * @param field 
	 * @param value 
	 * @return interp.variables.set(field, value)
	 */
	public function set(field:String, value:Dynamic)
		interp.variables.set(field, value);

	/**
		* [Checks the existence of a value or exposure within the module]
		* @param field 
		* @return Bool
				return interp.variables.exists(field)
	 */
	public function exists(field:String):Bool
		return interp.variables.exists(field);
}