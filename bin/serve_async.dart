import 'dart:isolate';
import 'package:hypertext_compare/hypertext_compare.dart';

main(List<String> args, [SendPort sendPort]) {
  var uri = Uri.parse(args.first);
  var rest = args.skip(1).toList();

  sendPort?.send('SERVE ASYNC: uri=$uri, args=$rest');
  return runMulti(uri, rest);
}
