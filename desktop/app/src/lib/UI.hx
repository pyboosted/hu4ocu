package lib;

import electron.IPC;
import electron.BrowserWindow;
import electron.App;
import electron.CrashReporter;

class UI {

  var window: BrowserWindow;
  var renderer: Dynamic;
  var APP_HEIGHT: Int = 617;
  public function new() {

    CrashReporter.start();

    App.on('window-all-closed', function () {
      App.quit();
    });

    App.on('ready', function () {
      window = new BrowserWindow({ 
        width: 420, 
        'min-width': 420, 
        'min-height': APP_HEIGHT,
        'max-height': APP_HEIGHT, 
        height: APP_HEIGHT, 
        frame: false, 
        show: false,
        icon: untyped __js__('__dirname') +  '/icon.png'
      });
      window.loadURL('file://' + untyped __js__('__dirname') + '/html/index.html');
      haxe.Timer.delay(function(){
        untyped window.show();
      }, 1000);
      window.openDevTools();
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

  public function when(event: String, fn:Dynamic->Dynamic) {
    IPC.on(event, function (event, args) {
      event.returnValue = fn(args);
      if (args != null && args.counter != null) {
        var res:Dynamic = event.returnValue;
        if (res == null) res = {};
        res.counter = args.counter;
        notify('response', res);
      }
    });
  }

  public function notify(event: String, data: Dynamic) {
    if (window != null && window.webContents != null) {
      window.webContents.send(event, data);
    }
  }

}