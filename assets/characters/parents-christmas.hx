import gameObjects.Character;
import Paths;

function onCharacterCreate(name){
    if(name == 'parents-christmas'){
        Character.instance.frames = Paths.getSparrowAtlas('characters/mom_dad_christmas_assets');
        Character.instance.animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
        Character.instance.animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
        Character.instance.animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
        Character.instance.animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
        Character.instance.animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

        Character.instance.animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

        Character.instance.animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
        Character.instance.animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
        Character.instance.animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

        Character.instance.playAnim('idle');
    }
}