package;
import flixel.FlxG;
class LogUtils {
    private static var lastLoggedMessages:Array<String> = new Array<String>();

    public static function log(message:String):Void {
        if (lastLoggedMessages[lastLoggedMessages.length - 1] == message) {
            return;
        }

        FlxG.log.notice(message);
        trace(message);
        lastLoggedMessages.push(message);
    }
}