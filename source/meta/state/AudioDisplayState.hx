package meta.state;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;
import meta.data.AudioDisplay;

class AudioDisplayState extends FlxState
{
	var test:AudioDisplay;

	override public function create()
	{
		FlxG.sound.playMusic("assets/music/displayInst.ogg", 1);
		test = new AudioDisplay(FlxG.sound.music, 0, FlxG.height / 2, FlxG.width, FlxG.height, 200, 4, FlxColor.WHITE);
		FlxG.stage.addChild(test);
	}

	override public function update(elapsed:Float)
	{
		test.draw(elapsed);
		super.update(elapsed);
	}
}
