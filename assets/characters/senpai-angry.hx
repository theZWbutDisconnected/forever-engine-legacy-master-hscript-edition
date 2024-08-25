import gameObjects.Character;
import Paths;
import Std;

function onCharacterCreate(name){
    if(name == 'senpai-angry'){
        Character.instance.frames = Paths.getSparrowAtlas('characters/senpai');
        Character.instance.animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
        Character.instance.animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
        Character.instance.animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
        Character.instance.animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
        Character.instance.animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

        Character.instance.setGraphicSize(Std.int(Character.instance.width * 6));
        Character.instance.updateHitbox();

        Character.instance.antialiasing = false;

        Character.instance.characterData.camOffsetY = -330;
        Character.instance.characterData.camOffsetX = -200;
    }
}