package ;

import lib.StaticServer;
import lib.UI;
import ws.Server as SocketServer;

import chats.Chats;
import chats.ChatProviders;

class App {

  var socketServer: SocketServer;
  var staticServer: StaticServer;
  var ui: UI;

  private function isWindows():Bool {
    return (untyped process.platform == 'win32');
  }

  public function new() {

    ui = new UI();

    var staticPath = isWindows() ? 'resources/app/html' : './html';

    socketServer = new SocketServer({ port: 8081 });
    staticServer = new StaticServer({ path: staticPath, port: 8080 });

    var chats = new Chats(this);

    chats.get(ChatProviders.Twitch).connect('squierpsn');
    chats.get(ChatProviders.Goodgame).connect('1542');

    chats.onMessage(function (message) {
      trace(message);
    });
  }

  public static function main() {

    var app = new App();
  }

}