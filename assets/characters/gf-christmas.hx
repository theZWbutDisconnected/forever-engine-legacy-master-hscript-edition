import gameObjects.Character;
import Paths;

function onCharacterCreate(name){
    if(name == 'gf-christmas'){
        Character.instance.tex = Paths.getSparrowAtlas('characters/gfChristmas');
        Character.instance.frames = Character.instance.tex;
        Character.instance.animation.addByPrefix('cheer', 'GF Cheer', 24, false);
        Character.instance.animation.addByPrefix('singLEFT', 'GF left note', 24, false);
        Character.instance.animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
        Character.instance.animation.addByPrefix('singUP', 'GF Up Note', 24, false);
        Character.instance.animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
        Character.instance.animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
        Character.instance.animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
        Character.instance.animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
        Character.instance.animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
        Character.instance.animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
        Character.instance.animation.addByPrefix('scared', 'GF FEAR', 24);

        Character.instance.playAnim('danceRight');
    }
}