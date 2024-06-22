package event;
import haxe.rtti.Meta;
import event.api.IEvent;
import haxe.Constraints.Function;
import haxe.ds.ObjectMap;
import meta.data.HScript;
class EventRegistry {
    private final registeredMethodMap:Map<{}, Class<IEvent>>;
    private final methodObjectMap:Map<{}, Dynamic>;
    private final priorityMethodMap:Map<{}, Array<{}>>;

    public function new() {
        registeredMethodMap = new Map<{}, Class<IEvent>>();
        methodObjectMap = new Map<{}, Dynamic>();
        priorityMethodMap = new Map<{}, Array<{}>>();
    }

    public function register(obj:Dynamic) {
        var clazz:Class<Dynamic> = Type.getClass(obj);
        var fields = Reflect.fields(obj);

        for (f in fields) {
            var field = Reflect.field(obj, f);
            if (Reflect.isFunction(field)) {
                var method:{} = cast field;
                if (hasOwnProperty(obj) && Reflect.field(f, "length") == 1) {
                    registeredMethodMap.set(method, getParameterTypes(method)[0]);
                    methodObjectMap.set(method, obj);
                    var paramType = getParameterTypes(method)[0];

                    if (paramType != null && Std.is(paramType, IEvent)) {
                        if (!priorityMethodMap.exists(paramType)) {
                            priorityMethodMap.set(paramType, []);
                        }
                        priorityMethodMap.get(paramType).push(method);
                    }
                }
            }
        }

        LogUtils.log("[Event Registry] Register Class Sucessfully: " + getClassName(obj));
        LogUtils.log("[Event Registry] Method Info: [registeredMethodMap]"
            + registeredMethodMap
            + ", [methodObjectMap]"
            + methodObjectMap
            + ", [priorityMethodMap]"
            + priorityMethodMap
        );
    }

    public function unregister(obj:Dynamic) {
        var clazz = Type.getClass(obj);
        var fields = Reflect.fields(obj);

        for (f in fields) {
            if (Reflect.isFunction(f)) {
                var method:{} = cast Reflect.field(obj, f);
                if (registeredMethodMap.exists(method)) {
                    registeredMethodMap.remove(method);
                    methodObjectMap.remove(method);
                }
            }
        }
    }

    public function triggerEvent(event:IEvent):Bool {
        var clazz = Type.getClass(event);
        var methods:Array<{}> = priorityMethodMap.get(cast clazz);
        if (methods != null) {
            for (method in methods) {
                var obj:Dynamic = methodObjectMap.get(method);
                Reflect.callMethod(event, cast method, [event]);
            }
            var isCancelled:Bool = Reflect.field(event, "isCancelled");
            if (isCancelled)
                LogUtils.log("[Event Trigger] Trigger Cancelled Event: " + getClassName(event));
            else
                LogUtils.log("[Event Trigger] Trigger Sucessfully Event: " + getClassName(event));
            return !isCancelled;
        }
        LogUtils.log("[Event] Not Method Listener On " + getClassName(event));
        return true;
    }

    public function triggerToMethod(event:IEvent, ?caller:Dynamic, ?methodName:String, ?handlers:Array<HScript>):Bool {
        var clazz = Type.getClass(event);
        if (handlers != null) {
            for (handler in handlers) {
                handler.get(methodName)(event);
            }
        }
        if (Reflect.hasField(caller, methodName)) {
            Reflect.callMethod(caller, cast Reflect.field(caller, methodName), [event]);
        }
        var isCancelled:Bool = Reflect.field(event, "isCancelled");
        if (isCancelled)
            LogUtils.log("[Event Trigger] Trigger Cancelled Event: " + getClassName(event));
        else
            LogUtils.log("[Event Trigger] Trigger Sucessfully Event: " + getClassName(event));
        return !isCancelled;
    }

    function getParameterTypes(method:{}) {
        var args:Array<Dynamic> = Reflect.fields(method);
        return args;
    }

    function getClassName(obj:Dynamic):String {
        return Type.getClassName(Type.getClass(obj));
    }

    function hasOwnProperty(obj:Dynamic):Bool {
        var classMeta = Meta.getFields(Type.getClass(obj));
        for (fieldName in Reflect.fields(obj)) {
            var fieldMeta = Reflect.field(classMeta, fieldName);
            if (fieldMeta != null && fieldMeta.EventHandler != null) {
                return true;
            }
        }
        return false;
    }
}
