import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:hypertext_compare/hypertext_compare.dart';

const List<String> LIBRARIES = const ['hypertext', 'io'];
const List<String> SERVERS = const ['hello', 'routing'];
final Uri SERVE_ASYNC = Platform.script.resolve('./serve_async.dart');

main(List<String> args) async {
  var result = PARSER.parse(args);
  int threads = int.parse(result['threads']);
  int connections = int.parse(result['connections']);
  int duration = int.parse(result['duration']);
  int port = int.parse(result['port']);
  print('serve_async URI: $SERVE_ASYNC');
  print('threads: $threads, connections: $connections, duration: ${duration}s');

  var resultDir = new Directory.fromUri(Platform.script.resolve('../results'));

  for (var server in SERVERS) {
    print('RUNNING SERVER: $server');
    var mdFile = new File.fromUri(resultDir.uri.resolve('$server.md'));
    if (!await mdFile.exists()) await mdFile.create(recursive: true);

    var md = mdFile.openWrite()
      ..writeln('# $server')
      ..writeln(
          'threads: $threads, connections: $connections, duration: ${duration}s');

    for (var library in LIBRARIES) {
      var sw = new Stopwatch()..start();
      md.writeln('## Using library: `$library`');

      var uri = Platform.script.resolve('./servers/$library/$server.dart');
      print('Running library "$library"...');
      md.writeln('Running Dart code from `$uri`');

      var recv = new ReceivePort()
        ..listen((data) => print('Data from isolate: $data'));
      var isolate = await Isolate.spawnUri(
          SERVE_ASYNC,
          []
            ..add(uri.toString())
            ..addAll(args),
          recv.sendPort);
      isolate.errors.listen(print, onError: (e, st) {
        md
          ..writeln('ERROR: Server $uri failed with: $e')
          ..writeln('```\n$st\n```');
      });

      await new Future.delayed(new Duration(seconds: 5));
      print('Running wrk...');
      var wrk = await runWrk('http://localhost:$port',
          duration: duration, connections: connections, threads: threads);
      print('wrk result:');
      print(wrk);
      sw.stop();
      md
        ..writeln('### `wrk` results for `$library`')
        ..writeln(wrk)
        ..writeln('### Total Time for `$library`:')
        ..writeln('${sw.elapsedMicroseconds} ms');

      isolate.kill();
      await new Future.delayed(new Duration(seconds: 5));
    }

    md.close();
    stdout.writeln();
  }

  exit(0);
}
