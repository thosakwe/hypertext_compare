import 'dart:io';
import 'dart:isolate';
import 'package:angel_route/angel_route.dart';

final RegExp _straySlashes = new RegExp(r'(^/+)|(/+$)');

main(args, [SendPort sendPort]) async {
  var port = 0;
  var server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, port);

  print('Now listening at http://localhost:${server.port}');

  var router = createRouter();

  await for (HttpRequest request in server) {
    // This is essentially the routing setup used in the Angel framework,
    // although simplified. ;)
    var requestedUrl = request.uri.toString().replaceAll(_straySlashes, '');
    if (requestedUrl.isEmpty) requestedUrl = '/';

    var resolved =
        router.resolveAll(requestedUrl, requestedUrl, method: request.method);
    var pipeline = new MiddlewarePipeline(resolved);

    for (var handler in pipeline.handlers) {
      if (await handler(request, request.response) != true) break;
    }

    await request.response.close();
  }

  sendPort?.send([server.address.address, server.port]);
}

Router createRouter() {
  return new Router()
    ..get('/hello', (req, HttpResponse res) async {
      res.write('Hello, world!');
    })
    ..all('*', (HttpRequest req, HttpResponse res) async {
      res
        ..statusCode = 404
        ..write("No file exists at path '${req.uri}'.".codeUnits);
    });
}
