package event.events;
import event.api.IEvent;
class MenuCreateEvent implements IEvent {
    public function new(name:String) {
        container = name;
    }

    public var isCancelled:Bool;
    public final container:String;
}
