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
  
  var usersInput: js.html.InputElement;
  var startBtn: js.html.DOMElement;
  var shuffleBtn: js.html.DOMElement;
  var saveBtn: js.html.DOMElement;
  var stopBtn: js.html.DOMElement;
  
  var slowingLabel: js.html.DOMElement;
  var speedingLabel: js.html.DOMElement;
  var winnerLabel: js.html.DOMElement;

  public function new() {

    doc = js.Browser.document;
    doc.addEventListener('DOMContentLoaded', function () {

      IPC.send('ready');

      config = IPC.sendSync('wheel.get');
      
      usersInput = cast doc.getElementById('users');
      shuffleBtn = doc.getElementById('shuffle');
      saveBtn = doc.getElementById('save');
      startBtn = doc.getElementById('start');
      stopBtn = doc.getElementById('stop');

      speedingLabel = doc.getElementById('speeding');
      slowingLabel = doc.getElementById('slowing');
      winnerLabel = doc.getElementById('winner');

      startBtn.addEventListener('click', function (_) {
        config = IPC.sendSync('wheel.start');
        updateBtns();
      });

      stopBtn.addEventListener('click', function (_) {
        config = IPC.sendSync('wheel.stop');
        updateBtns();
      });

      shuffleBtn.addEventListener('click', function (_) {
        config = IPC.sendSync('wheel.shuffle');
        updateUsers();
        updateBtns();
      });

      saveBtn.addEventListener('click', function (_) {
        var users = usersInput.value.split('\n');
        config = IPC.sendSync('wheel.update', users);
        updateUsers();
        updateBtns();
      });

      var timer = new haxe.Timer(500);
      timer.run = function () {
        config = IPC.sendSync('wheel.get');
        updateBtns();
      };

      updateUsers();
      updateBtns();

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

      slowingLabel.style.display = 'none';
      speedingLabel.style.display = 'none';
      winnerLabel.style.display = 'none';
    }

    if (config.status == 'speeding') {
      shuffleBtn.style.display = 'none';
      saveBtn.style.display = 'none';
      startBtn.style.display = 'none';
      stopBtn.style.display = 'none';

      slowingLabel.style.display = 'none';
      speedingLabel.style.display = 'inline';
      winnerLabel.style.display = 'none';
    };

    if (config.status == 'running') {
      shuffleBtn.style.display = 'none';
      saveBtn.style.display = 'none';
      startBtn.style.display = 'none';
      stopBtn.style.display = 'inline';

      slowingLabel.style.display = 'none';
      speedingLabel.style.display = 'none';
      winnerLabel.style.display = 'none';
    }

    if (config.status == 'slowing') {
      shuffleBtn.style.display = 'none';
      saveBtn.style.display = 'none';
      startBtn.style.display = 'none';
      stopBtn.style.display = 'none';

      slowingLabel.style.display = 'inline';
      speedingLabel.style.display = 'none';
      winnerLabel.style.display = 'none';
    };

    if (config.status == 'stopped') {
      shuffleBtn.style.display = 'inline';
      saveBtn.style.display = 'inline';
      startBtn.style.display = 'none';
      stopBtn.style.display = 'none';

      slowingLabel.style.display = 'none';
      speedingLabel.style.display = 'none';
      winnerLabel.style.display = 'inline';
      winnerLabel.innerHTML = 'Победитель: ' + config.list[config.winner];
    }
  }

  public static function main() {
    var client = new WheelClient();
  }

}