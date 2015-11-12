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

class Server {

  var ui: UI;
  var chats: Chats;
  var staticServer: StaticServer;
  var socketServer: SocketServer;

  private function _connectChatProviders() {

    
    var rutonyChat = new chats.RutonyChatProvider('ws://127.0.0.1:8383/Echo');
    rutonyChat.onStatusChanged(function (status) {
      trace(status);
    });
    rutonyChat.connect();


  }
  public function new(port: Int) {

    

    ui = new UI();
    staticServer = new StaticServer('../html', 8080);
    socketServer = new SocketServer({ port: 8081 });
    chats = new Chats();

    ui.on('ready', function (_) {
      trace('UI ready');
      chats.get(ChatProviders.Rutony).connect();

    });


  }

  public static function main() {
    var server = new Server(8080);
  }

}