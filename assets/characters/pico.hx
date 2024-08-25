import gameObjects.Character;
import Paths;

function onCharacterCreate(name){
    if(name == 'pico'){
        Character.instance.tex = Paths.getSparrowAtlas('characters/Pico_FNF_assetss');
        Character.instance.frames = Character.instance.tex;
        Character.instance.animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
        Character.instance.animation.addByPrefix('singUP', 'pico Up note0', 24, false);
        Character.instance.animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
        if (Character.instance.isPlayer)
        {
            Character.instance.animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
            Character.instance.animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
            Character.instance.animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
            Character.instance.animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
        }
        else
        {
            // Need to be flipped! REDO THIS LATER!
            Character.instance.animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
            Character.instance.animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
            Character.instance.animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
            Character.instance.animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
        }

        Character.instance.animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
        Character.instance.animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

        Character.instance.playAnim('idle');

        Character.instance.flipX = true;
    }
}