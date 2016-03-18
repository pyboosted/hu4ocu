package ;

class API {

  static inline function get(key: String, ?params: Dynamic):Dynamic {
    return IPC.sendSync(key, params);
  }

  static inline function on(key: String, callback: Dynamic->Dynamic->Void) {
    IPC.on(key, callback);
  }

} 
