package chats;

import ws.WebSocket;
import chats.Message;
import chats.ChatProvider;
import chats.ChatProviderStatus;

class GoodgameChatProvider extends ChatProvider {

  static var NICK:String = 'pyboosted';
  static var AUTH:String = 'oauth:qyejmtwbyc2y1qtm0wx1grjdneaibk';
  var socket: WebSocket;
  var host: String;
  var channel: String;
  public function new(host: String) {
    this.host = host;
    super();
  }

  public override function connect(channel) {
    tryReconnect = true;
    this.channel = channel;

    setStatus(ChatProviderStatus.Pending);
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

  public override function onConnect(_) {

    var connectionMessage:Dynamic = {
      type: "join",
      data: {
        channel_id: Std.parseInt(channel), // идентификатор канала
        hidden: false   // для модераторов: не показывать ник в списке юзеров
      }
    };

    socket.send(haxe.Json.stringify(connectionMessage));
    setStatus(ChatProviderStatus.Connected);

  }

  public override function disconnect() {
    tryReconnect = false;
    channel = null;
    socket.close();
    socket = null;
    setStatus(ChatProviderStatus.Disconnected);
  } 

  function processMessage(data: Dynamic):Void {
    var msg = haxe.Json.parse(data);  
    if (msg.type == 'message') {
      var name = msg.data.user_name;
      var text = msg.data.text;
      var message:Message = {
        source: MessageSource.Goodgame,
        username: name,
        text: text
      };
      this.notifyListeners(message);
    }
  }
}