package chats;

import ws.WebSocket;
import chats.ChatProvider;

import Formats;

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
    tryReconnect = true;
    this.channel = channel;

    setStatus(ChatProviderStatuses.Pending);


    node.Http.request('http://api.twitch.tv/api/channels/$channel/chat_properties', function (res) {
      
      var data = '';
      res.on('data', function (chunk) {
        data += chunk;
      });

      res.on('end', function () {
        
        var info = haxe.Json.parse(data);
        var server = info.web_socket_servers[0];

        trace('Connecting to: $server');
        try {
          socket = new WebSocket('ws://$server:80');
          socket.on('message', this.processMessage);
          socket.on('open', this.onConnect);
          socket.on('error', this.onDisconnect);
          socket.on('close', this.onDisconnect);
        } catch (e:Dynamic) {
          this.onDisconnect(e);
        }

      });

    }).end();
    
  }

  public override function onConnect(_) {
    socket.send('CAP REQ :twitch.tv/tags twitch.tv/commands twitch.tv/membership');
    socket.send('PASS ' + AUTH);
    socket.send('NICK ' + NICK);
    socket.send('JOIN #' + channel);
    setStatus(ChatProviderStatuses.Connected);
  }

  public override function disconnect() {
    tryReconnect = false;
    socket.close();
    socket = null;
    setStatus(ChatProviderStatuses.Disconnected);
  } 

  function processMessage(data: Dynamic):Void {

    if (data.lastIndexOf('PING', 0) == 0) {
      socket.send('PONG :tmi.twitch.tv');
      trace('PONG Sent\r\n');
      return;
    }

    var r = ~/.*?;display-name=(.*?);.*PRIVMSG #.+?:(.*)$/im;
    trace(data);
    if (r.match(data)) {
      var name = r.matched(1);
      var msg = r.matched(2);
      var message:ChatMessage = {
        source: MessageSources.Twitch,
        username: name,
        text: msg
      };
      this.notifyListeners(message);
    }
  }
}