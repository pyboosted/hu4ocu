package ;

import lib.StaticServer;
import lib.UI;
import ws.Server as SocketServer;

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

  }

  public static function main() {

    var app = new App();
  }

}