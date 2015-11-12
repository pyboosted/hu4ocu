package nodestatic;

@:jsRequire('node-static')
extern class Server {
  public static function __init__():Void untyped {
    Server = Server['Server'];
  }
  public function new(path: String):Void;
  public function serve(request:node.Http.Request, response: node.Http.Response, ?cb: Dynamic->Dynamic->Void):Void;
}