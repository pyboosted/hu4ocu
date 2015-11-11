package electron;

@:jsRequire('app')
extern class App {

  public static function on(eventName: String, handler: Void->Void):Void;
  public static function quit():Void;

}
