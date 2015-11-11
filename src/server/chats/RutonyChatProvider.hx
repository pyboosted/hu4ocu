package chats;

import ws.WebSocket;
import chats.Message;
import chats.ChatProvider;
import chats.ChatProviderStatus;

class RutonyChatProvider extends ChatProvider {

  private var _socket: WebSocket;
  private var _host: String;
  public function new(host: String) {
    _host = host;
    super();
  }

  public override function connect() {
    setStatus(ChatProviderStatus.Pending);
    try {
      _socket = new WebSocket('http://127.0.0.1:8383/Echo');
      _socket.on('message', this._processMessage);
      _socket.on('open', this._onConnect);
      _socket.on('error', this._onDisconnect);
      _socket.on('close', this._onDisconnect);
    } catch (e:Dynamic) {
      this._onDisconnect(e);
    }
  }

  public override function disconnect() {
    _socket.close();
    _socket = null;
    setStatus(ChatProviderStatus.Disconnected);
  } 

  private function _processMessage(data: Dynamic):Void {
    var obj = haxe.Json.parse(data);
    var message:Message = {
      source: obj.site_str,
      username: obj.user,
      text: obj.text
    };
    this.notifyListeners(message);
  }
}