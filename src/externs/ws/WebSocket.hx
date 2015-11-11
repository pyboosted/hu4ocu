package ws;


typedef ClientConfig = String;

@:jsRequire('ws')
extern class WebSocket {
  
  public function new(clientConfig: ClientConfig):Void;
  public function on(eventName: String, handler: Dynamic->Void):Void;
  public function close():Void;
}