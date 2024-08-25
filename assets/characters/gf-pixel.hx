import gameObjects.Character;
import meta.state.PlayState;
import Paths;
import Std;

function onCharacterCreate(name){
    if(name == 'gf-pixel'){
        Character.instance.tex = Paths.getSparrowAtlas('characters/gfPixel');
        Character.instance.frames = Character.instance.tex;
        Character.instance.animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
        Character.instance.animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
        Character.instance.animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

        Character.instance.addOffset('danceLeft', 0);
        Character.instance.addOffset('danceRight', 0);

        Character.instance.playAnim('danceRight');

        Character.instance.setGraphicSize(Std.int(Character.instance.width * PlayState.daPixelZoom));
        Character.instance.updateHitbox();
        Character.instance.antialiasing = false;
    }
}