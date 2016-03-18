package protobuf;

@:jsRequire('protobufjs')
extern class ProtobufJS {

  public static function pack(data: Dynamic):String;
  public static function unpack(data: node.Buffer):Dynamic;

}