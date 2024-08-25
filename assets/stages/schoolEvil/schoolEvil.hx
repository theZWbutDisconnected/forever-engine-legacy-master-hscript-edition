import meta.state.PlayState;
import meta.data.dependency.FNFSprite;
import Paths;

function onCreate(){
    var posX = 400;
    var posY = 200;
    var bg:FNFSprite = new FNFSprite(posX, posY);
    bg.frames = Paths.getStageSparrowAtlas(curStage, 'animatedEvilSchool');
    bg.animation.addByPrefix('idle', 'background 2', 24);
    bg.animation.play('idle');
    bg.scrollFactor.set(0.8, 0.9);
    bg.scale.set(6, 6);
    add(bg);
}