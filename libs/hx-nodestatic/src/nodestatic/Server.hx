package nodestatic;

import node.Http;

@:jsRequire('node-static')
extern class Server {
  public static function __init__():Void untyped {
    Server = Server['Server'];
  }
  public function new(path: String, ?config: Dynamic):Void;
  public function serve(request:ServerRequest, response: ServerResponse, ?cb: Dynamic->Dynamic->Void):Void;
}