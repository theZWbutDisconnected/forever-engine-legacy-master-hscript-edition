import meta.state.PlayState;
import meta.data.dependency.FNFSprite;
import Paths;
import Std;

var bgGirls:BackgroundGirls;
var fastCar:FNFSprite;

var limo:FNFSprite;


function onCreate(){
    curStage = 'highway';
    PlayState.defaultCamZoom = 0.90;

    var skyBG:FNFSprite = new FNFSprite(-120, -50).loadGraphic(Paths.stageImage(curStage,'limoSunset'));
    skyBG.scrollFactor.set(0.1, 0.1);
    add(skyBG);

    var bgLimo:FNFSprite = new FNFSprite(-200, 480);
    bgLimo.frames = Paths.getStageSparrowAtlas(curStage,'bgLimo');
    bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
    bgLimo.animation.play('drive');
    bgLimo.scrollFactor.set(0.4, 0.4);
    add(bgLimo);

    var overlayShit:FNFSprite = new FNFSprite(-500, -600).loadGraphic(Paths.stageImage(curStage,'limoOverlay'));
    overlayShit.alpha = 0.5;
    // add(overlayShit);

    // var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

    // FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

    // overlayShit.shader = shaderBullshit;

    var limoTex = Paths.getStageSparrowAtlas(curStage,'limoDrive');

    limo = new FNFSprite(-120, 550);
    limo.frames = limoTex;
    limo.animation.addByPrefix('drive', "Limo stage", 24);
    limo.animation.play('drive');
    limo.antialiasing = true;

    fastCar = new FNFSprite(-300, 160).loadGraphic(Paths.stageImage(curStage,'fastCarLol'));
}

function onUpdate(){}

function createLimo(){
    add(limo);
}