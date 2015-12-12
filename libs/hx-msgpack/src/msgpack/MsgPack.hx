package msgpack;

@:jsRequire('msgpack')
extern class MsgPack {

  public static function pack(data: Dynamic):String;
  public static function unpack(data: node.Buffer):Dynamic;

}