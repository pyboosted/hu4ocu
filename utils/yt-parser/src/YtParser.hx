package ;

using StringTools;

// import msgpack.MsgPack;
import phantom.Phantom;

class YtParser {

  static function getComments():Dynamic untyped {

    var comments = [];
    var elements:Array<js.html.Element> = document.querySelectorAll('#all-comments .comment');
    for (el in elements) {
      var nickname = el.querySelector('.yt-user-name').textContent;
      var comment = el.querySelector('.comment-text').textContent;
      comments.push({
        name: nickname,
        text: comment
      });
      el.remove();
    }

    return comments;

  }

  public static function main() {


    var phantom = Phantom.create({
      verbose: true,
      logLevel: 'debug',
      pageSettings: {
        loadImages:  true,
        userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.73 Safari/537.3',
        loadPlugins: true
      }
    });

    var channel = '';
    untyped {
      var system = require('system');
      var args = system.args;
      channel = args[1];
    }

    var url = 'https://www.youtube.com/live_chat?v=$channel&dark_theme=1&from_gaming=1&client_version=1.2';
    

    phantom.open(url, function () {

      var timer = new haxe.Timer(1000);
      var firstTick = true;
      timer.run = function () {
        var comments:Array<Dynamic> = phantom.evaluate(getComments);
        if (firstTick) {
          trace('ready');
          firstTick = false;
          return;
        }
        for (comment in comments) {
          trace('${comment.name.trim()}|||${comment.text.trim()}');
        }  
      };
      
    });
    
    
  }

}