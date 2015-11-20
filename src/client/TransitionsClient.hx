package ;

import electron.IPC;

typedef Config = {
  list: Array<String>,
  winner: Int,
  status: String
};

class WheelClient {

  var config:Config = null;

  var doc: js.html.Document;
  
  var colorInput: js.html.InputElement;
  var goBtn: js.html.DOMElement;
  
  public function new() {

    doc = js.Browser.document;
    doc.addEventListener('DOMContentLoaded', function () {

      IPC.send('ready');

      config = IPC.sendSync('transitions.get');
      
      colorInput = cast doc.getElementById('color');
      goBtn = doc.getElementById('go');

      goBtn.addEventListener('click', function (_) {
        config = IPC.sendSync('transitions.go');
      });

      updateColor();

    });
  }

  public function updateUsers() {
    usersInput.value = config.list.join('\n');
  }

  public function updateBtns() {

    if (config.status == 'not_running') {
      shuffleBtn.style.display = (config.list.length > 0) ? 'inline' : 'none';
      saveBtn.style.display = 'inline';
      startBtn.style.display = (config.list.length > 0) ? 'inline' : 'none';
      stopBtn.style.display = 'none';
    }

    if (config.status == 'running') {
      shuffleBtn.style.display = 'none';
      saveBtn.style.display = 'none';
      startBtn.style.display = 'none';
      stopBtn.style.display = 'inline';
    }

    if (config.status == 'stopped') {
      shuffleBtn.style.display = 'inline';
      saveBtn.style.display = 'inline';
      startBtn.style.display = 'none';
      stopBtn.style.display = 'none';
    }
  }

  public static function main() {
    var client = new WheelClient();
  }

}