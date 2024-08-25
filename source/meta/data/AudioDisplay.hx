package meta.data;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import funkin.vis.dsp.SpectralAnalyzer;
import openfl.display.Sprite;

/**
 * Authors Beihu
 * Modified by ZerWhit
 */
class AudioDisplay extends Sprite
{
	var analyzer:SpectralAnalyzer;

	public var snd:FlxSound;

	var _height:Int;
	var line:Int;
	var gap:Int;
	var members:Array<Float> = new Array<Float>();
	var Width:Int;
	var Height:Int;
	var Color:FlxColor;

	public function new(snd:FlxSound = null, X:Float = 0, Y:Float = 0, Width:Int, Height:Int, line:Int, gap:Int, Color:FlxColor)
	{
		super();
		this.x = x;
		this.y = Y;

		this.snd = snd;
		this.line = line;
		this.gap = gap;
		this.Width = Width;
		this.Height = Height;
		this.Color = Color;

		for (i in 0...line)
			members.push(0.0);

		_height = Height;
		@:privateAccess
		if (snd != null)
		{
			analyzer = new SpectralAnalyzer(snd._channel.__audioSource, line, 1, 5);
			analyzer.fftN = 256;
		}
	}

	public function draw(elapsed:Float)
	{
		addAnalyzer(snd);
		if (analyzer == null)
		{
			return;
		}
		var levels = analyzer.getLevels();

		graphics.clear();
		for (i in 0...line)
		{
			var animFrame:Int = Math.round(levels[i].value * _height);
			animFrame = Math.round(animFrame * FlxG.sound.volume);

			var barHeight = FlxMath.lerp(animFrame, members[i], Math.exp(-elapsed * 16));
			if (barHeight < 0.01)
				break;
			members[i] = barHeight;
			var barY = y - barHeight;

			graphics.beginFill(this.Color);
			graphics.drawRect((this.Width / line) * i, barY, Std.int(this.Width / line - gap), barHeight);
			graphics.endFill();
		}
	}

	function addAnalyzer(snd:FlxSound)
	{
		@:privateAccess
		if (snd != null && analyzer == null)
		{
			analyzer = new SpectralAnalyzer(snd._channel.__audioSource, line, 1, 5);
			analyzer.fftN = 256;
		}
	}

	public function changeAnalyzer(snd:FlxSound)
	{
		@:privateAccess
		analyzer.changeSnd(snd._channel.__audioSource);
	}
}
