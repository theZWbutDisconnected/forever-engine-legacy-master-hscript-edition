import meta.state.PlayState;
import meta.data.dependency.FNFSprite;
import gameObjects.background.BackgroundGirls;
import Paths;
import Std;

function onCreate(){
    curStage = 'school';

    // defaultCamZoom = 0.9;

    var bgSky = new FNFSprite().loadGraphic(Paths.stageImage(curStage, 'weebSky'));
    bgSky.scrollFactor.set(0.1, 0.1);
    add(bgSky);

    var repositionShit = -200;

    var bgSchool:FNFSprite = new FNFSprite(repositionShit, 0).loadGraphic(Paths.stageImage(curStage, 'weebSchool'));
    bgSchool.scrollFactor.set(0.6, 0.90);
    add(bgSchool);

    var bgStreet:FNFSprite = new FNFSprite(repositionShit).loadGraphic(Paths.stageImage(curStage, 'weebStreet'));
    bgStreet.scrollFactor.set(0.95, 0.95);
    add(bgStreet);

    var fgTrees:FNFSprite = new FNFSprite(repositionShit + 170, 130).loadGraphic(Paths.stageImage(curStage, 'weebTreesBack'));
    fgTrees.scrollFactor.set(0.9, 0.9);
    add(fgTrees);

    var bgTrees:FNFSprite = new FNFSprite(repositionShit - 380, -800);
    var treetex = Paths.getStagePackerAtlas(curStage, 'weebTrees');
    bgTrees.frames = treetex;
    bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
    bgTrees.animation.play('treeLoop');
    bgTrees.scrollFactor.set(0.85, 0.85);
    add(bgTrees);

    var treeLeaves:FNFSprite = new FNFSprite(repositionShit, -40);
    treeLeaves.frames = Paths.getStageSparrowAtlas(curStage, 'petals');
    treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
    treeLeaves.animation.play('leaves');
    treeLeaves.scrollFactor.set(0.85, 0.85);
    add(treeLeaves);

    var widShit = Std.int(bgSky.width * 6);

    bgSky.setGraphicSize(widShit);
    bgSchool.setGraphicSize(widShit);
    bgStreet.setGraphicSize(widShit);
    bgTrees.setGraphicSize(Std.int(widShit * 1.4));
    fgTrees.setGraphicSize(Std.int(widShit * 0.8));
    treeLeaves.setGraphicSize(widShit);

    fgTrees.updateHitbox();
    bgSky.updateHitbox();
    bgSchool.updateHitbox();
    bgStreet.updateHitbox();
    bgTrees.updateHitbox();
    treeLeaves.updateHitbox();

    bgGirls = new BackgroundGirls(-100, 190);
    bgGirls.scrollFactor.set(0.9, 0.9);

    if (PlayState.SONG.song.toLowerCase() == 'roses')
        bgGirls.getScared();

    bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
    bgGirls.updateHitbox();
    add(bgGirls);
}

function onBeat(curBeat){
    bgGirls.dance();
}