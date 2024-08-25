import gameObjects.Character;
import Paths;

function onCharacterCreate(name){
    if(name == 'bf-dead'){
        Character.instance.frames = Paths.getSparrowAtlas('characters/BF_DEATH');

        Character.instance.animation.addByPrefix('firstDeath', "BF dies", 24, false);
        Character.instance.animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
        Character.instance.animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

        Character.instance.playAnim('firstDeath');

        Character.instance.flipX = true;
    }
}