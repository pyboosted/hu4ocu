package ;

import electron.IPC;

class Client {

  public static function main() {
    
    js.Browser.document.addEventListener('DOMContentLoaded', function () {
      IPC.send('ready');
    });

  }

}