package ;

import js.Browser.document;
import Mithril.*;

import pages.Dashboard;
import pages.Chats;
import pages.Polls;
import pages.Wheel;

@:expose('UI') class UI {
  static function run() {

    untyped {
      history.pushState = function () {};
      history.replaceState = function () {};
    }

    route(document.getElementById('app'), '/', {
      '/': component(Dashboard, null),
      '/chats': component(Chats, null),
      '/polls': component(Polls, null),
      '/wheel': component(Wheel, null)
    });
    setRoute('/');
  }
  public static function main() {}
}
