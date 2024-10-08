import gameObjects.Character;
import Paths;

function onCharacterCreate(name){
    if(name == 'gf-car'){
        Character.instance.tex = Paths.getSparrowAtlas('characters/gfCar');
        Character.instance.frames = Character.instance.tex;
        Character.instance.animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
        Character.instance.animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
        Character.instance.animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,false);

        Character.instance.addOffset('danceLeft', 0);
        Character.instance.addOffset('danceRight', 0);

        Character.instance.playAnim('danceRight');
    }
}