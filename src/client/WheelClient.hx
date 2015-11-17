package ;

import electron.IPC;

class WheelClient {

  var config = null;

  var doc: js.html.Document;
  
  public function new() {

    doc = js.Browser.document;
    doc.addEventListener('DOMContentLoaded', function () {
      IPC.send('ready');
      config = IPC.sendSync('wheel.get');
    });
  }

  public static function main() {
    var client = new WheelClient();
  }

}