import 'dart:io';
import 'dart:isolate';
import 'package:hypertext/io.dart' as http;

main(args, [SendPort sendPort]) async {
  var port = 0;
  var server = await http.Server.bind(InternetAddress.LOOPBACK_IP_V4, port);
  print('Now listening at http://localhost:${server.connection.port}');

  await for (var request in server) {
    var res = request.response;

    // Send some HTML
    res
      ..headers.contentType = http.MediaTypes.HTML
      ..write('''
    <!DOCTYPE html>
    <html>
      <head>
        <title>Hello World</title>
      </head>
      <body>
        <h1>Hello World</h1>
        <p>Welcome to `package:hypertext`.
      </body>
    </html>
    ''');

    await res.close();
  }

  sendPort?.send([server.connection.address.address, server.connection.port]);
}
