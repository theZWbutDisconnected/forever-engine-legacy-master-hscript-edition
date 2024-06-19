package gameObjects;

/**
	The character class initialises any and all characters that exist within gameplay. For now, the character class will
	stay the same as it was in the original source of the game. I'll most likely make some changes afterwards though!
**/
import flixel.FlxG;
import flixel.addons.util.FlxSimplex;
import flixel.animation.FlxAnimation;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
// import flxanimate.FlxAnimate;
import gameObjects.userInterface.HealthIcon;
import haxe.ds.StringMap;
import lime.app.Application;
import meta.*;
import meta.data.*;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;
import openfl.utils.Assets as OpenFlAssets;
import sys.FileSystem;
import sys.io.File;

using StringTools;

typedef CharacterData =
{
	var offsetX:Float;
	var offsetY:Float;
	var camOffsetX:Float;
	var camOffsetY:Float;
	var zoomOffset:Float;
	var quickDancer:Bool;
}

class Character extends FNFSprite
{
	public static var instance:Character;

	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var canAnimate:Bool = true;
    //public var atlasCharacter:FlxAnimate; //shit
	public var atlasAnimation:String = '';

	public var holdTimer:Float = 0;

	public var characterData:CharacterData;
	public var adjustPos:Bool = true;

	public var tex:FlxAtlasFrames;

	public static var scriptHandler:HScript;

	public function new(?isPlayer:Bool = false)
	{
		super(x, y);
		instance = this;
		scriptHandler = new HScript();
		this.isPlayer = isPlayer;
	}

	public function setCharacter(x:Float, y:Float, character:String):Character
	{
		curCharacter = character;
		antialiasing = true;

		characterData = {
			offsetY: 0,
			offsetX: 0,
			camOffsetY: 0,
			camOffsetX: 0,
	        zoomOffset:0,
			quickDancer: false
		};
		var tex:FlxAtlasFrames;

		/*if (atlasCharacter != null && atlasCharacter.exists)
			atlasCharacter.destroy();*/

	    var exposure:StringMap<Dynamic> = new StringMap<Dynamic>();
	    exposure.set('curCharacter', curCharacter);
		try
		{
		    try
		    {
				characterArray();
			    scriptHandler.loadModule(Paths.hxs('characters/$curCharacter'), exposure);
			}
		    catch (e:Dynamic)
		    {
		    	Application.current.window.alert('An error while loading character($curCharacter):\nmissing character file', "Character Error!");
		    	setDefaultCharacter();
		    }
	        if (scriptHandler.exists("onCharacterCreate"))
				scriptHandler.get("onCharacterCreate")(curCharacter);
			if (frames == null /*&& atlasCharacter == null*/)
			{
				Application.current.window.alert('An error while loading character($curCharacter):\nmissing image files', "Character Error!");
				setDefaultCharacter();
			}
	    }
	    catch (e:Dynamic)
	    {
	    	Application.current.window.alert('An error while creating character($curCharacter):\n'+e, "Character Error!");
			setDefaultCharacter();
		}
		
		// set up offsets cus why not
		if (OpenFlAssets.exists(Paths.offsetTxt(curCharacter + 'Offsets')))
		{
			var characterOffsets:Array<String> = CoolUtil.coolTextFile(Paths.offsetTxt(curCharacter + 'Offsets'));
			for (i in 0...characterOffsets.length)
			{
				var getterArray:Array<Array<String>> = CoolUtil.getOffsetsFromTxt(Paths.offsetTxt(curCharacter + 'Offsets'));
				addOffset(getterArray[i][0], Std.parseInt(getterArray[i][1]), Std.parseInt(getterArray[i][2]));
			}
		}

		dance();

		if (isPlayer) // fuck you ninjamuffin lmao
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
				flipLeftRight();
			//
		}
		else if (curCharacter.startsWith('bf'))
			flipLeftRight();

		if (adjustPos)
		{
			x += characterData.offsetX;
			trace('character ${curCharacter} scale ${scale.y}');
			y += (characterData.offsetY - (frameHeight * scale.y));
		}

		this.x = x;
		this.y = y;

		/*if (atlasCharacter != null)
			atlasCharacter.setPosition(this.x, this.y);*/

		return this;
	}

	public var characterList:Array<String> = [];
	
	public function characterArray(){
		var tempCharacterArray:Array<String> = FileSystem.readDirectory('assets/characters');
		characterList.splice(0, characterList.length);
	    for (character in tempCharacterArray)
	    {
	    	if (character.contains('.'))
	    	{
	    		character = character.substring(0, character.indexOf('.', 0));
	    		characterList.push(character);
	    	}
	    	else
	    		characterList.push(character);
	    }
    }
	function setDefaultCharacter()
	{
		frames = Paths.getSparrowAtlas('characters/BOYFRIEND');
		animation.addByPrefix('idle', 'BF idle dance', 24, false);
		animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
		animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
		animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
		animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
		animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
		animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
		animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
		animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
		animation.addByPrefix('hey', 'BF HEY', 24, false);
		animation.addByPrefix('scared', 'BF idle shaking', 24);
		playAnim('idle');
		flipX = true;
		characterData.offsetY = 70;
	}
	function flipLeftRight():Void
	{
		// get the old right sprite
		var oldRight = animation.getByName('singRIGHT').frames;

		// set the right to the left
		animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;

		// set the left to the old right
		animation.getByName('singLEFT').frames = oldRight;

		// insert ninjamuffin screaming I think idk I'm lazy as hell

		if (animation.getByName('singRIGHTmiss') != null)
		{
			var oldMiss = animation.getByName('singRIGHTmiss').frames;
			animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
			animation.getByName('singLEFTmiss').frames = oldMiss;
		}
	}

	override function update(elapsed:Float)
	{
		if (!isPlayer)
		{
			/*if (atlasCharacter != null)
				if (atlasAnimation.startsWith('sing'))
					holdTimer += elapsed;
			else*/
				if (animation.curAnim.name.startsWith('sing'))
					holdTimer += elapsed;

			var dadVar:Float = 4;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		var curCharSimplified:String = simplifyCharacter();
		switch (curCharSimplified)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
				if ((animation.curAnim.name.startsWith('sad')) && (animation.curAnim.finished))
					playAnim('danceLeft');
		}

		// Post idle animation (think Week 4 and how the player and mom's hair continues to sway after their idle animations are done!)
		if (animation.curAnim.finished && animation.curAnim.name == 'idle')
		{
			// We look for an animation called 'idlePost' to switch to
			if (animation.getByName('idlePost') != null)
				// (( WE DON'T USE 'PLAYANIM' BECAUSE WE WANT TO FEED OFF OF THE IDLE OFFSETS! ))
				animation.play('idlePost', true, false, 0);
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(?forced:Bool = false)
	{
		if (!debugMode)
		{
			var curCharSimplified:String = simplifyCharacter();
			/*if (atlasCharacter != null)
			{
				playAnim('idle', forced);
			}
			else
			{*/
				switch (curCharSimplified)
				{
					case 'gf':
						if ((!animation.curAnim.name.startsWith('hair')) && (!animation.curAnim.name.startsWith('sad')))
						{
							if (animation.getByName('danceLeft') != null && animation.getByName('danceRight') != null)
							{
								danced = !danced;
								if (danced)
									playAnim('danceRight', forced);
								else
									playAnim('danceLeft', forced);
							}
							else
								playAnim('idle', forced);
						}
					default:
						// Left/right dancing, think Skid & Pump
						if (animation.getByName('danceLeft') != null && animation.getByName('danceRight') != null)
						{
							danced = !danced;
							if (danced)
								playAnim('danceRight', forced);
							else
								playAnim('danceLeft', forced);
						}
						else
							playAnim('idle', forced);
				}
		    //}
		}
	}

	public static function generateIndicesAtPoint(point:Int, amount:Int):Array<Int>
	{
		var returnArray:Array<Int> = [];
		for (i in 0...amount)
			returnArray.push((point - 1) + i);
		return returnArray;
	}

	public var currentIndex:Int = 1;

	public function indicesContinueAmount(amount:Int):Array<Int>
	{
		var theArray:Array<Int> = generateIndicesAtPoint(currentIndex, amount);
		currentIndex += amount;
		return theArray;
	}

	override public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
				danced = true;
			else if (AnimName == 'singRIGHT')
				danced = false;

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
				danced = !danced;
		}

		if (animation.getByName(AnimName) != null)
		{
			/*if (!canAnimate
				|| (atlasAnimation.contains('transition')
					&& ((!atlasCharacter.anim.reversed && atlasCharacter.anim.curFrame < 3)
						|| (atlasCharacter.anim.reversed && atlasCharacter.anim.curFrame > 2))))
			{
				return;
			}
			else
				canAnimate = true;

			if (atlasCharacter != null)
			{
				atlasCharacter.anim.play(AnimName, Force, Reversed, Frame);
				atlasAnimation = AnimName;
			}
			else
			{*/
				super.playAnim(AnimName, Force, Reversed, Frame);
			//}
	    }
	}

	public function simplifyCharacter():String
	{
		var base = curCharacter;

		if (base.contains('-'))
			base = base.substring(0, base.indexOf('-'));
		return base;
	}
}
