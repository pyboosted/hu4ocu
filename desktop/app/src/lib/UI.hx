package lib;

import electron.IPC;
import electron.BrowserWindow;
import electron.App;
import electron.CrashReporter;

class UI {

  var window: BrowserWindow;
  var renderer: Dynamic;

  public function new() {

    CrashReporter.start();

    App.on('window-all-closed', function () {
      App.quit();
    });

    App.on('ready', function () {
      window = new BrowserWindow({ 
        width: 420, 
        'min-width': 420, 
        'min-height': 597,
        'max-height': 597, 
        height: 597, 
        frame: false, 
        show: false,
        icon: untyped __js__('__dirname') +  '/icon.png'
      });
      window.loadUrl('file://' + untyped __js__('__dirname') + '/html/index.html');
      haxe.Timer.delay(function(){
        untyped window.show();
      }, 1000);
      // window.openDevTools();
      window.on('closed', function () {
        window = null;
      });
    });

    this.on('quit', function (_) {
      App.quit();
      return null;
    });

  }

  public function on(event: String, fn: Dynamic->Void):Void {
    IPC.on(event, function (event, args) {
      fn(args);
    });
  }

  public function send(event: String, data: Dynamic):Void {
    IPC.send(event, data);
  }

  // server only
  public function when(event: String, fn:Dynamic->Dynamic) {
    IPC.on(event, function (event, args) {
      event.returnValue = fn(args);
    });
  }

  // client only
  public function call(event: String, data: Dynamic):Dynamic {
    return IPC.sendSync(event, data);
  };

}