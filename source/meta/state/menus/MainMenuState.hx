package meta.state.menus;

import event.events.MenuCreateEvent;
import event.events.MenuUpdateEvent;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import haxe.ds.StringMap;
import meta.MusicBeat.MusicBeatState;
import meta.data.AudioDisplay;
import meta.data.HScript;
import meta.data.dependency.Discord;
import sys.FileSystem;

using StringTools;

/**
	This is the main menu state! Not a lot is going to change about it so it'll remain similar to the original, but I do want to condense some code and such.
	Get as expressive as you can with this, create your own menu!
**/
class MainMenuState extends MusicBeatState
{
	var handlers:Array<HScript> = [];

	var menuItems:FlxTypedGroup<FlxSprite>;
	var curSelected:Float = 0;

	var bg:FlxSprite; // the background has been separated for more control
	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var optionShit:Array<String> = ['story mode', 'freeplay', 'options'];
	var canSnap:Array<Float> = [];

	// the create 'state'
	override function create()
	{
		super.create();

		Main.EVENT_BUS.register(this);

		var exposure = new StringMap<Dynamic>();
		exposure.set('menuItems', menuItems);
		exposure.set('curSelected', curSelected);
		exposure.set('bg', bg);
		exposure.set('magenta', magenta);
		exposure.set('camFollow', camFollow);
		exposure.set('optionShit', optionShit);
		exposure.set('canSnap', canSnap);
		exposure.set('add', add);
		exposure.set('remove', remove);

		var dirs = FileSystem.readDirectory("assets/scripts");
		for (file in dirs)
		{
			if (file.endsWith(".hx"))
			{
				var handler = new HScript();
				handler.loadModule(Paths.scripts(file), exposure);
				handlers.push(handler);
			}
		}

		// set the transitions to the previously set ones
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		// make sure the music is playing
		ForeverTools.resetMenuMusic();

		#if DISCORD_RPC
		Discord.changePresence('MENU SCREEN', 'Main Menu');
		#end

		// uh
		persistentUpdate = persistentDraw = true;

		// background
		bg = new FlxSprite(-85);
		bg.loadGraphic(Paths.image('menus/base/menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;

		magenta = new FlxSprite(-85).loadGraphic(Paths.image('menus/base/menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;

		// add the camera
		camFollow = new FlxObject(0, 0, 1, 1);

		// add the menu items
		menuItems = new FlxTypedGroup<FlxSprite>();

		// from the base game lol

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Forever Engine Legacy v" + Main.gameVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		if (Main.EVENT_BUS.triggerToMethod(new MenuCreateEvent("mainmenu"), this, "onMenuCreateEvent", handlers))
		{
			add(bg);

			add(magenta);

			add(camFollow);

			add(menuItems);

			// create the menu items themselves
			var tex = Paths.getSparrowAtlas('menus/base/title/FNF_main_menu_assets');

			// loop through the menu options
			for (i in 0...optionShit.length)
			{
				var menuItem:FlxSprite = new FlxSprite(0, 80 + (i * 200));
				menuItem.frames = tex;
				// add the animations in a cool way (real
				menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				menuItem.animation.play('idle');
				canSnap[i] = -1;
				// set the id
				menuItem.ID = i;
				// menuItem.alpha = 0;

				// placements
				menuItem.screenCenter(X);
				// if the id is divisible by 2
				if (menuItem.ID % 2 == 0)
					menuItem.x += 1000;
				else
					menuItem.x -= 1000;

				// actually add the item
				menuItems.add(menuItem);
				menuItem.scrollFactor.set();
				menuItem.antialiasing = true;
				menuItem.updateHitbox();

				/*
					FlxTween.tween(menuItem, {alpha: 1, x: ((FlxG.width / 2) - (menuItem.width / 2))}, 0.35, {
						ease: FlxEase.smootherStepInOut,
						onComplete: function(tween:FlxTween)
						{
							canSnap[i] = 0;
						}
				});*/
			}

			updateSelection();
		}
		add(versionShit);

		for (handler in handlers)
		{
			handler.get("onMenuCreatePost")("mainmenu");
		}

		// set the camera to actually follow the camera object that was created before
		var camLerp = Main.framerateAdjust(0.10);
		FlxG.camera.follow(camFollow, null, camLerp);

		//
	}

	// var colorTest:Float = 0;
	var selectedSomethin:Bool = false;
	var counterControl:Float = 0;

	override function update(elapsed:Float)
	{
		if (Main.EVENT_BUS.triggerToMethod(new MenuUpdateEvent("mainmenu").setElapsed(elapsed), this, "onMenuUpdateEvent", handlers))
		{
			// colorTest += 0.125;
			// bg.color = FlxColor.fromHSB(colorTest, 100, 100, 0.5);

			var up = controls.UI_UP;
			var down = controls.UI_DOWN;
			var up_p = controls.UI_UP_P;
			var down_p = controls.UI_DOWN_P;
			var controlArray:Array<Bool> = [up, down, up_p, down_p];

			if ((controlArray.contains(true)) && (!selectedSomethin))
			{
				for (i in 0...controlArray.length)
				{
					// here we check which keys are pressed
					if (controlArray[i] == true)
					{
						// if single press
						if (i > 1)
						{
							// up is 2 and down is 3
							// paaaaaiiiiiiinnnnn
							if (i == 2)
								curSelected--;
							else if (i == 3)
								curSelected++;

							FlxG.sound.play(Paths.sound('scrollMenu'));
						}
						/* idk something about it isn't working yet I'll rewrite it later
							else
							{
								// paaaaaaaiiiiiiiinnnn
								var curDir:Int = 0;
								if (i == 0)
									curDir = -1;
								else if (i == 1)
									curDir = 1;

								if (counterControl < 2)
									counterControl += 0.05;

								if (counterControl >= 1)
								{
									curSelected += (curDir * (counterControl / 24));
									if (curSelected % 1 == 0)
										FlxG.sound.play(Paths.sound('scrollMenu'));
								}
						}*/

						if (curSelected < 0)
							curSelected = optionShit.length - 1;
						else if (curSelected >= optionShit.length)
							curSelected = 0;
					}
					//
				}
			}
			else
			{
				// reset variables
				counterControl = 0;
			}

			if ((controls.ACCEPT) && (!selectedSomethin))
			{
				//
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				FlxFlicker.flicker(magenta, 0.8, 0.1, false);

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0, x: FlxG.width * 2}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
						{
							var daChoice:String = optionShit[Math.floor(curSelected)];

							switch (daChoice)
							{
								case 'story mode':
									Main.switchState(this, new StoryMenuState());
								case 'freeplay':
									Main.switchState(this, new FreeplayState());
								case 'options':
									transIn = FlxTransitionableState.defaultTransIn;
									transOut = FlxTransitionableState.defaultTransOut;
									Main.switchState(this, new OptionsMenuState());
							}
						});
					}
				});
			}

			if (Math.floor(curSelected) != lastCurSelected)
				updateSelection();
		}

		for (handler in handlers)
		{
			handler.get("onMenuUpdatePost")(elapsed, "mainmenu");
		}

		super.update(elapsed);

		menuItems.forEach(function(menuItem:FlxSprite)
		{
			menuItem.screenCenter(X);
		});
	}

	var lastCurSelected:Int = 0;

	private function updateSelection()
	{
		// reset all selections
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();
		});

		// set the sprites and all of the current selection
		if (menuItems.members[Math.floor(curSelected)] != null)
		{
			camFollow.setPosition(menuItems.members[Math.floor(curSelected)].getGraphicMidpoint().x,
				menuItems.members[Math.floor(curSelected)].getGraphicMidpoint().y);

			if (menuItems.members[Math.floor(curSelected)].animation.curAnim.name == 'idle')
				menuItems.members[Math.floor(curSelected)].animation.play('selected');

			menuItems.members[Math.floor(curSelected)].updateHitbox();
		}

		lastCurSelected = Math.floor(curSelected);
	}

	override function add(obj:FlxBasic):FlxBasic
	{
		if (Reflect.hasField(obj, "antialiasing"))
			Reflect.setField(obj, "antialiasing", Init.gameSettings.get("Disable Antialiasing"));
		return super.add(obj);
	}
}
