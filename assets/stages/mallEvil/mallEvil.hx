import meta.state.PlayState;
import meta.data.dependency.FNFSprite;
import Paths;
import Std;

function onCreate(){
    curStage = 'mallEvil';
    var bg:FNFSprite = new FNFSprite(-400, -500).loadGraphic(Paths.stageImage(curStage,'evilBG'));
    bg.antialiasing = true;
    bg.scrollFactor.set(0.2, 0.2);
    bg.active = false;
    bg.setGraphicSize(Std.int(bg.width * 0.8));
    bg.updateHitbox();
    add(bg);

    var evilTree:FNFSprite = new FNFSprite(300, -300).loadGraphic(Paths.stageImage(curStage,'evilTree'));
    evilTree.antialiasing = true;
    evilTree.scrollFactor.set(0.2, 0.2);
    add(evilTree);

    var evilSnow:FNFSprite = new FNFSprite(-200, 700).loadGraphic(Paths.stageImage(curStage,"evilSnow"));
    evilSnow.antialiasing = true;
    add(evilSnow);
}