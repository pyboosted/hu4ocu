package ;

import electron.IPC;

class PollsClient {

  var config = null;

  var doc: js.html.Document;
  var q1Input: js.html.InputElement;
  var q2Input: js.html.InputElement;
  var key1Input: js.html.InputElement;
  var key2Input: js.html.InputElement;
  
  var list1: js.html.Element;
  var list2: js.html.Element;
  
  var startBtn: js.html.DOMElement;
  var saveBtn: js.html.DOMElement;
  var stopBtn: js.html.DOMElement;
  var resetBtn: js.html.DOMElement;
  var showBtn: js.html.DOMElement;
  var hideBtn: js.html.DOMElement;

  public function new() {

    doc = js.Browser.document;
    doc.addEventListener('DOMContentLoaded', function () {

      IPC.send('ready');
      
      config = IPC.sendSync('polls.get');

      q1Input = cast doc.getElementById('q1');
      q2Input = cast doc.getElementById('q2');
      key1Input = cast doc.getElementById('key1');
      key2Input = cast doc.getElementById('key2');

      list1 = doc.getElementById('list1');
      list2 = doc.getElementById('list2');

      saveBtn = doc.getElementById('save');
      startBtn = doc.getElementById('start');
      stopBtn = doc.getElementById('stop');
      resetBtn = doc.getElementById('reset');

      showBtn = doc.getElementById('show');
      hideBtn = doc.getElementById('hide');

      startBtn.addEventListener('click', function (_) {
        config = IPC.sendSync('polls.start');
        updateBtns();
      });

      stopBtn.addEventListener('click', function (_) {
        config = IPC.sendSync('polls.stop');
        updateBtns();
      });

      resetBtn.addEventListener('click', function (_) {
        config = IPC.sendSync('polls.reset');
        updateBtns();
      });

      showBtn.addEventListener('click', function (_) {
        config = IPC.sendSync('polls.show');
        updateBtns();
      });
      hideBtn.addEventListener('click', function (_) {
        config = IPC.sendSync('polls.hide');
        updateBtns();
      });

      saveBtn.addEventListener('click', function (_) {
        var cfg = {
          q1: q1Input.value,
          q2: q2Input.value,
          key1: key1Input.value,
          key2: key2Input.value
        };
        config = IPC.sendSync('polls.set', cfg);
        updateBtns();
      });

      updateBtns();

      var timer = new haxe.Timer(1000);
      timer.run = function () {

        config = IPC.sendSync('polls.get');
        updateLists();

      };
    });
  }

  public function updateBtns() {

    switch (config.status) {

      case 'not_running':
        stopBtn.style.display = 'none';
        startBtn.style.display = 'inline';
        resetBtn.style.display = 'inline';
        saveBtn.style.display = 'inline';
      case 'running':
        stopBtn.style.display = 'inline';
        startBtn.style.display = 'none';
        resetBtn.style.display = 'none';
        saveBtn.style.display = 'inline';
      case 'stopped':
        stopBtn.style.display = 'none';
        startBtn.style.display = 'inline';
        resetBtn.style.display = 'inline';
        saveBtn.style.display = 'inline';
    }

    switch (config.visual) {
      case 'hidden':
        showBtn.style.display = 'inline';
        hideBtn.style.display = 'none';
      case 'visible':
        hideBtn.style.display = 'inline';
        showBtn.style.display = 'none';
    }

    q1Input.value = config.q1;
    q2Input.value = config.q2;

    key1Input.value = config.key1;
    key2Input.value = config.key2;

    updateLists();
  }

  function updateLists() {
    list1.innerHTML = config.votes1.join('\n');
    list2.innerHTML = config.votes2.join('\n');
  }



  public static function main() {
    var client = new PollsClient();
  }

}