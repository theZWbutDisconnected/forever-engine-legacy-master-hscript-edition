import meta.state.PlayState;
import meta.data.dependency.FNFSprite;
import Std;
import Paths;

function onCreate(){
    PlayState.defaultCamZoom = 0.9;
    var bg:FNFSprite = new FNFSprite(-600, -200);
    bg.loadGraphic(Paths.stageImage(curStage, 'stageback'));
    bg.antialiasing = true;
    bg.scrollFactor.set(0.9, 0.9);
    bg.active = false;

    // add to the final array
    add(bg);

    var stageFront:FNFSprite = new FNFSprite(-650, 600);
    stageFront.loadGraphic(Paths.stageImage(curStage, 'stagefront'));
    stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
    stageFront.updateHitbox();
    stageFront.antialiasing = true;
    stageFront.scrollFactor.set(0.9, 0.9);
    stageFront.active = false;

    // add to the final array
    add(stageFront);

    var stageCurtains:FNFSprite = new FNFSprite(-500, -300);
    stageCurtains.loadGraphic(Paths.stageImage(curStage, 'stagecurtains'));
    stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
    stageCurtains.updateHitbox();
    stageCurtains.antialiasing = true;
    stageCurtains.scrollFactor.set(1.3, 1.3);
    stageCurtains.active = false;

    // add to the final array
    add(stageCurtains);
}