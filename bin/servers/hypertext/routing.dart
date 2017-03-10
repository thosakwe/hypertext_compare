import 'dart:io';
import 'dart:isolate';
import 'package:angel_route/angel_route.dart';
import 'package:hypertext/io.dart' as http;

final RegExp _straySlashes = new RegExp(r'(^/+)|(/+$)');

main(args, [SendPort sendPort]) async {
  var port = 0;
  var server = await http.Server.bind(InternetAddress.LOOPBACK_IP_V4, port);

  print('Now listening at http://localhost:${server.connection.port}');

  var router = createRouter();

  await for (http.Request request in server) {
    // This is essentially the routing setup used in the Angel framework,
    // although simplified. ;)
    var requestedUrl = request.url.replaceAll(_straySlashes, '');
    if (requestedUrl.isEmpty) requestedUrl = '/';

    var resolved =
        router.resolveAll(requestedUrl, requestedUrl, method: request.method);
    var pipeline = new MiddlewarePipeline(resolved);

    for (var handler in pipeline.handlers) {
      if (await handler(request, request.response) != true) break;
    }

    await request.response.close();
  }

  sendPort?.send([server.connection.address.address, server.connection.port]);
}

Router createRouter() {
  return new Router()
    ..get('/hello', (req, http.Response res) async {
      res.write('Hello, world!');
    })
    ..all('*', (http.Request req, http.Response res) async {
      res
        ..statusCode = 404
        ..message = 'Not Found'
        ..write("No file exists at path '${req.url}'.");
    });
}
