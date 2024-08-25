import gameObjects.Character;
import Paths;
import Std;

function onCharacterCreate(name){
    if(name == 'spirit'){
        Character.instance.frames = Paths.getPackerAtlas('characters/spirit');
        Character.instance.animation.addByPrefix('idle', "idle spirit_", 24, false);
        Character.instance.animation.addByPrefix('singUP', "up_", 24, false);
        Character.instance.animation.addByPrefix('singRIGHT', "right_", 24, false);
        Character.instance.animation.addByPrefix('singLEFT', "left_", 24, false);
        Character.instance.animation.addByPrefix('singDOWN', "spirit down_", 24, false);

        Character.instance.setGraphicSize(Std.int(Character.instance.width * 6));
        Character.instance.updateHitbox();

        Character.instance.playAnim('idle');

        Character.instance.antialiasing = false;
        Character.instance.characterData.quickDancer = true;

        Character.instance.characterData.camOffsetY = 50;
        Character.instance.characterData.camOffsetX = 100;
    }
}