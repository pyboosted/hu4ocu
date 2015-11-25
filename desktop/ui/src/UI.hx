package ;

import js.Browser.document;
import Mithril.*;

import pages.Chats;
import pages.Polls;
import pages.Wheel;
import pages.About;

@:expose('UI') class UI {

  static function __init__() {
    untyped {
      if (!require) document.require = function () {};
    }
  }

  static function run() {

    untyped {
      history.pushState = function () {};
      history.replaceState = function () {};
    }

    route(document.getElementById('app'), '/chats', {
      '/chats': component(Chats, null),
      '/polls': component(Polls, null),
      '/wheel': component(Wheel, null),
      '/about': component(About, null),
    });
    setRoute('/chats');
  }
  public static function main() {}
}
