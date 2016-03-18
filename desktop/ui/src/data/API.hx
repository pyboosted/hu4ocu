package data;

import electron.IPCRenderer;

class API {

  public static function __init__() {

    API.on('response', function (data) {
      if (data.counter != null && listeners.exists(data.counter)) {
        listeners.get(data.counter)(null, data);
        listeners.remove(data.counter);
      }
    });

  }
  public static inline function get(key: String, ?params: Dynamic):Dynamic {
    return IPCRenderer.sendSync(key, params);
  }

  public static var counter: Int = 0;
  public static var listeners: Map<Int, Dynamic->Dynamic->Void> = new Map<Int, Dynamic->Dynamic->Void>();

  public static function async(key: String, params: Dynamic, fn: Dynamic->Dynamic->Void) {
    listeners.set(counter, fn);
    if (params == null) params = {};
    params.counter = counter;
    API.get(key, params);
    counter++;
  }

  public static inline function on(key: String, callback: Dynamic->Void) {
    IPCRenderer.on(key, function (_, data) {
      callback(data);
    });
  }

} 
