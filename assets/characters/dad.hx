import gameObjects.Character;
import Paths;

function onCharacterCreate(name){
    if(name == 'dad'){
        Character.instance.tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST');
        Character.instance.frames = Character.instance.tex;
        Character.instance.animation.addByPrefix('idle', 'Dad idle dance', 24, false);
        Character.instance.animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
        Character.instance.animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
        Character.instance.animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
        Character.instance.animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

        Character.instance.playAnim('idle');
    }
}