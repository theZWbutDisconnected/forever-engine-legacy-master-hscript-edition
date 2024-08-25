import gameObjects.Character;
import Paths;

function onCharacterCreate(name){
    if(name == 'bf'){
        Character.instance.frames = Paths.getSparrowAtlas('characters/BOYFRIEND');

        Character.instance.animation.addByPrefix('idle', 'BF idle dance', 24, false);
        Character.instance.animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
        Character.instance.animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
        Character.instance.animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
        Character.instance.animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
        Character.instance.animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
        Character.instance.animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
        Character.instance.animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
        Character.instance.animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
        Character.instance.animation.addByPrefix('hey', 'BF HEY', 24, false);
        Character.instance.animation.addByPrefix('scared', 'BF idle shaking', 24);

        Character.instance.playAnim('idle');

        Character.instance.flipX = true;

        Character.instance.characterData.offsetY = 70;
    }
}