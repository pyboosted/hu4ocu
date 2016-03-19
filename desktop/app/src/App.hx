package ;

import lib.StaticServer;
import lib.UI;
import ws.Server as SocketServer;

import chats.Chats;

import services.Polls;

class App {

  public var socketServer: SocketServer;
  public var staticServer: StaticServer;


  public var ui: UI;

  public var chats: Chats;
  public var polls: Polls;

  private function isWindows():Bool {
    return (untyped process.platform == 'win32');
  }

  public function new() {

    ui = new UI();

    var staticPath = isWindows() ? 'resources/app/html' : './html';

    socketServer = new SocketServer({ port: 8081 });
    staticServer = new StaticServer({ path: staticPath, port: 8080 });

    chats = new Chats(this);
    chats.onMessage(function (message) {
      trace(message);
    });

    polls = new Polls(this);

  }

  public static function main() {

    var app = new App();
  }

}