package electron;

@:jsRequire('electron', 'ipcMain')
extern class IPC {
  public static function on(eventName: String, handler: Dynamic->Dynamic->Void):Void;
}