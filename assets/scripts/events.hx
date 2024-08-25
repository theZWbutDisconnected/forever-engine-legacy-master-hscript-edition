import meta.state.PlayState;
import Std;
import Math;

function onEventFunction(name,value1,value2){
    switch (name)
    {
        case 'Add Camera Zoom':
            switch (value1){
                case 'camGame':
                    PlayState.camGame.zoom += Std.parseFloat(value2);
                case 'camHUD':
                    PlayState.camHUD.zoom += Std.parseFloat(value2);
                case 'strumHUD':
                    PlayState.strumHUD[0].zoom += Std.parseFloat(value2);
                    PlayState.strumHUD[1].zoom += Std.parseFloat(value2);
                case 'camOther':
                    PlayState.camOther.zoom += Std.parseFloat(value2);
            }
        case 'Camera Bop Speed':
            var intensity = Std.parseFloat(value1);
            if (Math.isNaN(intensity))
                intensity = 0;
            var speed = Std.parseFloat(value2);
            if (Math.isNaN(speed)) 
                speed = 0;
            PlayState.instance.bopIntensity = intensity;
            PlayState.instance.bopFrequency = speed;
    }
}

function returnEventDescription(name){
    switch (name){
        case 'Add Camera Zoom':
            return "Value 1: camera\nValue 2: zoom";
        case 'Camera Bop Speed':
            return "Basically just does what the name says\nValue 1: intensity\nValue 2: speed";
    }
    return '';
}

function returnEventsList(){
    return ['Add Camera Zoom', 'Camera Bop Speed'];
}