package electron;

@:jsRequire('ipc')
extern class IPC {

  public static function on(eventName: String, handler: Dynamic->Dynamic->Void):Void;
  public static function send(channel: String, ?data: Dynamic = null):Void;
  public static function sendSync(channel: String, ?data: Dynamic = null):Dynamic;
}