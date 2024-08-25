import gameObjects.Character;
import Paths;
import Std;

function onCharacterCreate(name){
    if(name == 'bf-pixel'){
        Character.instance.frames = Paths.getSparrowAtlas('characters/bfPixel');
        Character.instance.animation.addByPrefix('idle', 'BF IDLE', 24, false);
        Character.instance.animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
        Character.instance.animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
        Character.instance.animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
        Character.instance.animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
        Character.instance.animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
        Character.instance.animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
        Character.instance.animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
        Character.instance.animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

        Character.instance.setGraphicSize(Std.int(Character.instance.width * 6));
        Character.instance.updateHitbox();

        Character.instance.playAnim('idle');

        Character.instance.width -= 100;
        Character.instance.height -= 100;

        Character.instance.antialiasing = false;

        Character.instance.flipX = true;
    }
}