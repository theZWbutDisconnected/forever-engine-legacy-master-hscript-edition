import gameObjects.Character;
import Paths;

function onCharacterCreate(name){
    if(name == 'bf-pixel'){
        Character.instance.frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD');
        Character.instance.animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
        Character.instance.animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
        Character.instance.animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
        Character.instance.animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
        Character.instance.animation.play('firstDeath');

        // pixel bullshit
        Character.instance.setGraphicSize(Std.int(Character.instance.width * 6));
        Character.instance.updateHitbox();
        Character.instance.antialiasing = false;
        Character.instance.flipX = true;

        Character.instance.characterData.offsetY = 180;
    }
}