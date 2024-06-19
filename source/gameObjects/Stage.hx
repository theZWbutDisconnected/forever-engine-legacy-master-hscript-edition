package gameObjects;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import gameObjects.background.*;
import haxe.ds.StringMap;
import lime.app.Application;
import meta.CoolUtil;
import meta.data.Conductor;
import meta.data.HScript;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;
import sys.FileSystem;
import sys.io.File;

using StringTools;

/**
	This is the stage class. It sets up everything you need for stages in a more organised and clean manner than the
	base game. It's not too bad, just very crowded. I'll be adding stages as a separate
	thing to the weeks, making them not hardcoded to the songs.
**/
class Stage extends FlxTypedGroup<FlxBasic>
{
	public var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;

	public var curStage:String;

	var daPixelZoom = PlayState.daPixelZoom;

	public var foreground:FlxTypedGroup<FlxBasic>;

	public static var instance:Stage;

	public static var stageHandler:HScript;

	public static var exposure:StringMap<Dynamic>;

	public function new(curStage)
	{
		super();
		this.curStage = curStage;

		instance = this;
		stageHandler = new HScript();

		exposure = new StringMap<Dynamic>();
		exposure.set('add', add);
		exposure.set('addInPlayState', addInPlayState);

		exposure.set('curStage', curStage);
		exposure.set('daPixelZoom', daPixelZoom);
		exposure.set('defaultCamZoom', PlayState.defaultCamZoom);

		exposure.set('gfVersion', gfVersion);
		try
		{
			stageHandler.loadModule(Paths.hxs('stages/$curStage/$curStage'), exposure);
		}
		catch (e:Dynamic)
		{
			Application.current.window.alert("An error while loading the stage:\n" + e, "Stage Error!");
		}

        //fuck the bitches don't spawn
		switch (curStage){
			case 'highway':
				grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
				add(grpLimoDancers);

				for (i in 0...5)
				{
					var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, -480);
					dancer.scrollFactor.set(0.4, 0.4);
					grpLimoDancers.add(dancer);
				}
		}

		/// get hardcoded stage type if chart is fnf style
		if (PlayState.determinedChartType == "FNF")
		{
			// this is because I want to avoid editing the fnf chart type
			// custom stage stuffs will come with forever charts
			if (stageHandler.exists("onCreate"))
				stageHandler.get("onCreate")();
			PlayState.curStage = curStage;
		}

		// to apply to foreground use foreground.add(); instead of add();
		foreground = new FlxTypedGroup<FlxBasic>();
	}

	public var stageList:Array<String> = [];

	public function stageArray()
	{
		var tempStageArray:Array<String> = FileSystem.readDirectory('assets/stages');
		stageList.splice(0, stageList.length);
		for (stage in tempStageArray)
		{
			if (stage.contains('.'))
			{
				stage = stage.substring(0, stage.indexOf('.', 0));
				stageList.push(stage);
			}
			else
				stageList.push(stage);
		}
	}

	var gfVersion:String = 'gf';

	// return the girlfriend's type
	public function returnGFtype(curStage)
	{

		if (stageHandler.exists("returnGFtype"))
			gfVersion = stageHandler.get("returnGFtype")();

		switch (curStage)
		{
			case 'highway':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
		}

		return gfVersion;
	}

	// get the dad's position
	public function dadPosition(curStage, boyfriend:Character, dad:Character, gf:Character, camPos:FlxPoint):Void
	{
		var characterArray:Array<Character> = [dad, boyfriend];
		for (char in characterArray)
		{
			switch (char.curCharacter)
			{
				case 'gf':
					char.setPosition(gf.x, gf.y);
					gf.visible = false;
					/*
						if (isStoryMode)
						{
							camPos.x += 600;
							tweenCamIn();
					}*/
					/*
						case 'spirit':
							var evilTrail = new FlxTrail(char, null, 4, 24, 0.3, 0.069);
							evilTrail.changeValuesEnabled(false, false, false, false);
							add(evilTrail);
					 */
			}
		}
	}

	public function repositionPlayers(curStage, boyfriend:Character, dad:Character, gf:Character):Void
	{
		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'highway':
				boyfriend.y -= 220;
				boyfriend.x += 260;

			case 'mall':
				boyfriend.x += 200;
				dad.x -= 400;
				dad.y += 20;

			case 'mallEvil':
				boyfriend.x += 320;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				dad.x += 200;
				dad.y += 580;
				gf.x += 200;
				gf.y += 320;
			case 'schoolEvil':
				dad.x -= 150;
				dad.y += 50;
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
		}
	}

	public function stageUpdate(curBeat:Int, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		if (stageHandler.exists("onBeat"))
			stageHandler.get("onBeat")(curBeat, boyfriend, gf, dadOpponent);
		// trace('update backgrounds');
		switch (PlayState.curStage)
		{
			case 'highway':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});
		}
	}

	public function stageUpdateConstant(elapsed:Float, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		if (stageHandler.exists("onUpdate"))
			stageHandler.get("onUpdate")(elapsed, boyfriend, gf, dadOpponent);
	}

	override function add(Object:FlxBasic):FlxBasic
	{
		if (Init.trueSettings.get('Disable Antialiasing') && Std.isOfType(Object, FlxSprite))
			cast(Object, FlxSprite).antialiasing = false;
		return super.add(Object);
	}

	public function addInPlayState(Object:FlxBasic):FlxBasic
	{
		if (Init.trueSettings.get('Disable Antialiasing') && Std.isOfType(Object, FlxSprite))
			cast(Object, FlxSprite).antialiasing = false;
		return PlayState.instance.addByStage(Object);
	}
}
