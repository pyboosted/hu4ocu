package layout;

import Mithril.*;

import components.Nav;

class Layout {
  public static function around(content: Mithril.Node) return m('.row', [ 
    m('.sidebar.col',component(Nav, null)),
    m('.content.col', content)
  ]);
}
