package ;

import electron.App;
import electron.BrowserWindow;
import electron.CrashReporter;
import electron.IPC;

import ws.WebSocket;

class Server {

  var _window: BrowserWindow = null;
  var _chatProviders: Map<String, chats.ChatProvider>;

  private function _serveStatic(path: String) {
    var fileServer = new nodestatic.Server(path);
    var httpServer = node.Http.createServer(function (req, res) {
      req.addListener('end', function () {
        fileServer.serve(req, res);
      }).resume();
    });

    httpServer.listen(8080);
  }

  private function _connectChatProviders() {

    _chatProviders = new Map<String, chats.ChatProvider>();
    var rutonyChat = new chats.RutonyChatProvider('ws://127.0.0.1:8383/Echo');
    rutonyChat.onStatusChanged(function (status) {
      trace(status);
    });
    rutonyChat.connect();

    _chatProviders.set('rutony', rutonyChat);

  }

  public function new(port: Int) {

    CrashReporter.start();

    App.on('window-all-closed', function () {
      App.quit();
    });

    App.on('ready', function () {
      _window = new BrowserWindow({ width: 1200, height: 700 });
      _window.loadUrl('file://' + untyped __js__('__dirname') + '/../ui/index.html');
      _window.openDevTools();
      _window.on('closed', function () {
        _window = null;
      });
    });

    IPC.on('ready', function (event, args) {

      _serveStatic('./html');
      _connectChatProviders();

    });

  }

  public static function main() {

    var server = new Server(8080);


  }

}