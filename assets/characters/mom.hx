import gameObjects.Character;
import Paths;

function onCharacterCreate(name){
    if(name == 'mom'){
        Character.instance.tex = Paths.getSparrowAtlas('characters/Mom_Assets');
        Character.instance.frames = Character.instance.tex;

        Character.instance.animation.addByPrefix('idle', "Mom Idle", 24, false);
        Character.instance.animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
        Character.instance.animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
        Character.instance.animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
        // ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
        // CUZ DAVE IS DUMB!

        // maybe youre just dumb for not telling him to name it that
        // dw im also dumb
        Character.instance.animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

        Character.instance.playAnim('idle');

        Character.instance.characterData.camOffsetY = 100;
    }
}