package ;

import ws.Server;

/*
  This is a rutony-chat websocket mockup. 
  It generates random messages and sends it to all connected clients.
  [http://rutony-studio.com/ru/rutonychat/api/]
*/

class RandomMessageGenerator {

  static var usernames: Array<String> = ['squier', 'welovegames', 'lirik', 'rutony'];
  static var messages: Array<String> = ['^_^', '1', '2', 'Всем привет!'];
  static var sources: Array<String> = ['GG', 'Twitch', 'YouTube'];

  public static function generateMessage() {

    var username = usernames[Std.random(usernames.length)];
    var message = messages[Std.random(messages.length)];
    var source = sources[Std.random(sources.length)];

    return {
      site_str: source,
      text: message,
      user: username
    };

  }


}

class RutonyMock {

  public static function main() {

    var server = new ws.Server({ port: 8383 });
    var timer = new haxe.Timer(2000);

    timer.run = function () {
      
      var message = RandomMessageGenerator.generateMessage();
      trace('[Broadcasting] ${message.user} [${message.site_str}]: ${message.text}');
      server.broadcast(haxe.Json.stringify(RandomMessageGenerator.generateMessage()));
      
    };

  }

}