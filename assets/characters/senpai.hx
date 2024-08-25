import gameObjects.Character;
import Paths;
import Std;

function onCharacterCreate(name){
    if(name == 'senpai'){
        Character.instance.frames = Paths.getSparrowAtlas('characters/senpai');
        Character.instance.animation.addByPrefix('idle', 'Senpai Idle', 24, false);
        Character.instance.animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
        Character.instance.animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
        Character.instance.animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
        Character.instance.animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

        Character.instance.playAnim('idle');

        Character.instance.setGraphicSize(Std.int(Character.instance.width * 6));
        Character.instance.updateHitbox();

        Character.instance.antialiasing = false;

        Character.instance.characterData.camOffsetY = -330;
        Character.instance.characterData.camOffsetX = -200;
    }
}