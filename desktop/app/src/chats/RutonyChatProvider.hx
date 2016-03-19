package chats;

import ws.WebSocket;
import chats.ChatProvider;

import Formats;

class RutonyChatProvider extends ChatProvider {

  var socket: WebSocket;
  var host: String;

  public function new(host: String) {
    this.host = host;
    super();
  }

  public override function connect(_) {
    setStatus(ChatProviderStatuses.Pending);
    try {
      socket = new WebSocket(host);
      socket.on('message', this.processMessage);
      socket.on('open', this.onConnect);
      socket.on('error', this.onDisconnect);
      socket.on('close', this.onDisconnect);
    } catch (e:Dynamic) {
      this.onDisconnect(e);
    }
  }

  public override function disconnect() {
    socket.close();
    socket = null;
    setStatus(ChatProviderStatuses.Disconnected);
  } 

  function processMessage(data: Dynamic):Void {
    var obj = haxe.Json.parse(data);
    var message:ChatMessage = {
      source: obj.site_str,
      username: obj.user,
      text: obj.text
    };
    this.notifyListeners(message);
  }
}