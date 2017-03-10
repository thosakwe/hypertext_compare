import 'dart:async';
import 'dart:io';
import 'package:args/args.dart';
import 'package:angel_multiserver/angel_multiserver.dart';

final ArgParser PARSER = new ArgParser()
  ..addOption('threads',
      abbr: 't',
      help: 'The number of threads to run wrk on. Defaults to 10.',
      defaultsTo: '10')
  ..addOption('connections',
      abbr: 'c',
      help: 'The number of connection to run in wrk. Defaults to 100.',
      defaultsTo: '100')
  ..addOption('duration',
      abbr: 'd',
      help: 'The number of seconds to run wrk for. Defaults to 30.',
      defaultsTo: '30')
  ..addOption('port',
      abbr: 'p',
      help: 'The port to listen on. Defaults to 3000.',
      defaultsTo: '3000');

Future runMulti(Uri uri, List<String> args) async {
  var result = PARSER.parse(args);
  int threads = int.parse(result['threads']);
  int port = int.parse(result['port']);
  print('Starting $threads instances for multiserver...');

  var loadBalancer = new LoadBalancer(maxConcurrentConnections: threads);
  await loadBalancer.spawnIsolates(uri, count: threads);

  loadBalancer.onCrash.listen((_) {
    print('Endpoint crashed, starting a new one...');
    return loadBalancer.spawnIsolates(uri);
  });

  var server =
      await loadBalancer.startServer(InternetAddress.LOOPBACK_IP_V4, port);
  print('Multiserver up at http://${server.address.address}:${server.port}');
}

Future<String> runWrk(String url,
    {int threads, int connections, int duration}) async {
  var p = await Process
      .run('wrk', ['-t$threads', '-c$connections', '-d$duration', url]);

  if (p.exitCode != 0 || p.stderr != null && p.stderr?.isNotEmpty == true) {
    stderr.writeln(p.stdout);
    stderr.writeln(p.stderr);
    throw new StateError('wrk failed.');
  }

  return p.stdout;
}
