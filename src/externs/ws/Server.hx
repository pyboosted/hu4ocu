package ws;

typedef ServerConfig = {
  ?port: Int,
  ?server: String
}

typedef ServerClient = {
  ?send: String->Void
}

@:jsRequire('ws')
extern class Server {
  
  public static function __init__():Void untyped {
    Server = Server['Server'];
  }

  public var clients: Array<ServerClient>;
  public function new(config: ServerConfig):Void {}
  public inline function broadcast(message:String):Void {
    for (client in clients) {
      client.send(message);
    }
  }
  public function on(event: String, fn:Dynamic->Void):Void;
}