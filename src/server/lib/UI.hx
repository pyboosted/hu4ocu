package lib;

import electron.IPC;
import electron.BrowserWindow;
import electron.App;
import electron.CrashReporter;

class UI {

  var window: BrowserWindow;
  var renderer: Dynamic;

  public function new() {

    // CrashReporter.start();

    App.on('window-all-closed', function () {
      App.quit();
    });

    App.on('ready', function () {
      window = new BrowserWindow({ width: 1400, height: 700 });
      window.loadUrl('file://' + untyped __js__('__dirname') + '/../ui/index.html');
      // window.openDevTools();
      window.on('closed', function () {
        window = null;
      });
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

  public function log(message: String) {
    // if (renderer != null) renderer.send('log', message);
  }

}