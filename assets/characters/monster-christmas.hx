import gameObjects.Character;
import Paths;

function onCharacterCreate(name){
    if(name == 'monster-christmas'){
        Character.instance.tex = Paths.getSparrowAtlas('characters/monsterChristmas');
        Character.instance.frames = Character.instance.tex;
        Character.instance.animation.addByPrefix('idle', 'monster idle', 24, false);
        Character.instance.animation.addByPrefix('singUP', 'monster up note', 24, false);
        Character.instance.animation.addByPrefix('singDOWN', 'monster down', 24, false);
        Character.instance.animation.addByPrefix('singRIGHT', 'Monster left note', 24, false);
        Character.instance.animation.addByPrefix('singLEFT', 'Monster Right note', 24, false);

        Character.instance.playAnim('idle');
    }
}