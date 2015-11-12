package ;

import electron.IPC;

class Client {

  public static function main() {
    
    js.Browser.document.addEventListener('DOMContentLoaded', function () {

      var logEl = js.Browser.document.getElementById('log');
      var log = [];

      IPC.send('ready');

      IPC.on('log', function (_, message: Dynamic) {
        log.push(message);
        logEl.innerHTML = log.join('\n');
      });
    });



  }

}