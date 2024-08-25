import meta.state.PlayState;
import meta.data.dependency.FNFSprite;
import Paths;

function onCreate(){
    curStage = 'spooky';
    // halloweenLevel = true;

    var hallowTex = Paths.getStageSparrowAtlas(curStage, 'halloween_bg');

    halloweenBG = new FNFSprite(-200, -100);
    halloweenBG.frames = hallowTex;
    halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
    halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
    halloweenBG.animation.play('idle');
    halloweenBG.antialiasing = true;
    add(halloweenBG);
}