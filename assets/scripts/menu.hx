//example menu event handler

@:EventHandler
function onMenuCreateEvent(event) {
    event.isCancelled = false;
    if (event.container == "mainmenu"){
        trace("This is an example mainmenu event handler!");
    } else if (event.container == "freeplay") {
        trace("This is an example freeplay menu event handler!");
    }
}

function onMenuCreatePost(container) {
    if (container == "mainmenu"){
        trace("This is an example mainmenu method handler!");
    } else if (container == "freeplay") {
        trace("This is an example freeplay menu method handler!");
    }
}

@:EventHandler
function onMenuUpdateEvent(event) {
    event.isCancelled = false;
}

function onMenuUpdatePost(elapsed, container) {
}