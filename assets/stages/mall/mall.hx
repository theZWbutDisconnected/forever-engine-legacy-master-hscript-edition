import meta.state.PlayState;
import meta.data.dependency.FNFSprite;
import Paths;
import Std;

var upperBoppers:FNFSprite;
var bottomBoppers:FNFSprite;
var santa:FNFSprite;

function onCreate(){
    curStage = 'mall';
    PlayState.defaultCamZoom = 0.80;

    var bg:FNFSprite = new FNFSprite(-1000, -500).loadGraphic(Paths.stageImage(curStage,'bgWalls'));
    bg.antialiasing = true;
    bg.scrollFactor.set(0.2, 0.2);
    bg.active = false;
    bg.setGraphicSize(Std.int(bg.width * 0.8));
    bg.updateHitbox();
    add(bg);

    upperBoppers = new FNFSprite(-240, -90);
    upperBoppers.frames = Paths.getStageSparrowAtlas(curStage,'upperBop');
    upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
    upperBoppers.antialiasing = true;
    upperBoppers.scrollFactor.set(0.33, 0.33);
    upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
    upperBoppers.updateHitbox();
    add(upperBoppers);

    var bgEscalator:FNFSprite = new FNFSprite(-1100, -600).loadGraphic(Paths.stageImage(curStage,'bgEscalator'));
    bgEscalator.antialiasing = true;
    bgEscalator.scrollFactor.set(0.3, 0.3);
    bgEscalator.active = false;
    bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
    bgEscalator.updateHitbox();
    add(bgEscalator);

    var tree:FNFSprite = new FNFSprite(370, -250).loadGraphic(Paths.stageImage(curStage,'christmasTree'));
    tree.antialiasing = true;
    tree.scrollFactor.set(0.40, 0.40);
    add(tree);

    bottomBoppers = new FNFSprite(-300, 140);
    bottomBoppers.frames = Paths.getStageSparrowAtlas(curStage,'bottomBop');
    bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
    bottomBoppers.antialiasing = true;
    bottomBoppers.scrollFactor.set(0.9, 0.9);
    bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
    bottomBoppers.updateHitbox();
    add(bottomBoppers);

    var fgSnow:FNFSprite = new FNFSprite(-600, 700).loadGraphic(Paths.stageImage(curStage,'fgSnow'));
    fgSnow.active = false;
    fgSnow.antialiasing = true;
    add(fgSnow);

    santa = new FNFSprite(-840, 150);
    santa.frames = Paths.getStageSparrowAtlas(curStage,'santa');
    santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
    santa.antialiasing = true;
    add(santa);
}

function onBeat(){
    upperBoppers.animation.play('bop', true);
    bottomBoppers.animation.play('bop', true);
    santa.animation.play('idle', true);
}