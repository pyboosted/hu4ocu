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

  public static var chats = new data.Chats();
  public static var polls = new data.Polls();
  public static var wheel = new data.Wheel();

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
  public static function update() {
    redraw();
  }
}
