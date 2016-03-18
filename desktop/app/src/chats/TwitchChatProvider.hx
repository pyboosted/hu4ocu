package chats;

import ws.WebSocket;
import chats.Message;
import chats.ChatProvider;
import chats.ChatProviderStatus;

class TwitchChatProvider extends ChatProvider {

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
    socket.send('CAP REQ :twitch.tv/tags twitch.tv/commands twitch.tv/membership');
    socket.send('PASS ' + AUTH);
    socket.send('NICK ' + NICK);
    socket.send('JOIN #' + channel);
    setStatus(ChatProviderStatus.Connected);
  }

  public override function disconnect() {
    channel = null;
    socket.close();
    socket = null;
    setStatus(ChatProviderStatus.Disconnected);
  } 

  function processMessage(data: Dynamic):Void {
    var r = ~/.*?;display-name=(.*?);.*PRIVMSG #.+?:(.*)$/im;
    if (r.match(data)) {
      var name = r.matched(1);
      var msg = r.matched(2);
      var message:Message = {
        source: MessageSource.Twitch,
        username: name,
        text: msg
      };
      this.notifyListeners(message);
    }
  }
}