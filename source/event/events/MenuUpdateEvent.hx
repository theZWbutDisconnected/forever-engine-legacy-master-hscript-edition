package event.events;
import event.api.IEvent;
class MenuUpdateEvent implements IEvent {
    public function new(name:String) {
        container = name;
    }

    public var isCancelled:Bool;
    private var elapsed:Float;
    public final container:String;

    public function setElapsed(elapsed:Float){
        this.elapsed = elapsed;
        return this;
    }
}
