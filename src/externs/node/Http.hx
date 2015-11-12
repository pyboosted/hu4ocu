package node;

typedef Request = {
  public function addListener(eventName: String, handler:Void->Void):Request;
  public function resume():Request;
  public var url: String;
}
typedef Response = Dynamic;

typedef HttpServer = {
  public function listen(port: Int):Void;
}

@:jsRequire('http')
extern class Http {
  public static function createServer(handler:Request->Response->Void):HttpServer;
}