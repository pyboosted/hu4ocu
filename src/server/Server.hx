package ;

import electron.App;
import electron.BrowserWindow;
import electron.CrashReporter;
import electron.IPC;

import ws.Server as SocketServer;
import lib.StaticServer;
import lib.UI;

import chats.Chats;
import chats.ChatProviders;

import services.Polls;

class Server {

  public var ui: UI;
  public var chats: Chats;
  public var staticServer: StaticServer;
  public var socketServer: SocketServer;
  public var polls: Polls;

  public function new(port: Int) {
    ui = new UI();

    var staticPath = './html';
    if (untyped process.platform == 'win32') {
      staticPath = 'resources/app/html';
    }
    
    staticServer = new StaticServer(staticPath, 8080);
    socketServer = new SocketServer({ port: 8081 });
    chats = new Chats(this);
    chats.get(Rutony).connect();
    polls = new Polls(this);
    
    ui.on('ready', function (_) {
      
      ui.when('get', function (data) {
        return polls.getConfig();
      });

      ui.when('start', function (_) {
        polls.start();
        return polls.getConfig();
      });

      ui.when('stop', function (_) {
        polls.stop();
        return polls.getConfig();
      });

      ui.when('reset', function (_) {
        polls.reset();
        return polls.getConfig();
      });

      ui.when('set', function (config) {
        polls.setConfig(config);
        return polls.getConfig();
      });

    });

    

  }

  public static function main() {
    var server = new Server(8080);
  }

}