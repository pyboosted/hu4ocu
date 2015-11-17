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
import services.Wheel;

class Server {

  public var ui: UI;
  public var chats: Chats;
  public var staticServer: StaticServer;
  public var socketServer: SocketServer;

  public var polls: Polls;
  public var wheel: Wheel;

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
    wheel = new Wheel(this);
    

  }

  public static function main() {
    var server = new Server(8080);
  }

}