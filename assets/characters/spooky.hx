import gameObjects.Character;
import Paths;

function onCharacterCreate(name){
    if(name == 'spooky'){
        Character.instance.tex = Paths.getSparrowAtlas('characters/spooky_kids_assets');
        Character.instance.frames = Character.instance.tex;
        Character.instance.animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
        Character.instance.animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
        Character.instance.animation.addByPrefix('singLEFT', 'note sing left', 24, false);
        Character.instance.animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
        Character.instance.animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
        Character.instance.animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

        Character.instance.characterData.quickDancer = true;

        Character.instance.playAnim('danceRight');
    }
}