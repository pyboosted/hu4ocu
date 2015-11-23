package ;

import js.Browser.document;
import Mithril.*;

@:expose('UI') class UI {
  
  static function run() {

    trace('run');

    route(document.getElementById('app'), '/', {
      '/': component(Root, null)
    });

    setRoute('/');
  }

  public static function main() {
    trace('desktop/ui');
  }

}

class Root {
  public function new(_) {}
  public function view() return m('.root');
}