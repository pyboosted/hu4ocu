package electron;

typedef WindowConfig = {
  width: Int,
  height: Int,
  ?frame: Bool
}

typedef WebContents = {
  var send: Dynamic->Dynamic->Void;
}

@:jsRequire('electron', 'BrowserWindow')
extern class BrowserWindow {

  public var webContents: WebContents;
  public function new(windowConfig: Dynamic):Void;
  public function loadURL(url: String):Void;
  public function openDevTools():Void;
  public function on(eventName:String, handler: Void->Void):Void;

}