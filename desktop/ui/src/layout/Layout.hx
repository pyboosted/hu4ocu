package layout;

import Mithril.*;

import components.Nav;

class Layout {
  public static function around(content: Mithril.Node) return m('div', [ 
    m('.sidebar',component(Nav, null)),
    m('.content', content)
  ]);
}
