# routing
threads: 20, connections: 200, duration: 10s
## Using library: `hypertext`
Running Dart code from `file:///Users/tobe/Source/Dart/hypertext_compare/bin/servers/hypertext/routing.dart`
ERROR: Server file:///Users/tobe/Source/Dart/hypertext_compare/bin/servers/hypertext/routing.dart failed with: SocketException: Failed to create server socket (OS Error: The shared flag to bind() needs to be `true` if binding multiple times on the same (address, port) combination.), address = 127.0.0.1, port = 3000
```
#0      _NativeSocket.bind.<anonymous closure> (dart:io-patch/socket_patch.dart:524)
#1      _RootZone.runUnary (dart:async/zone.dart:1404)
#2      _FutureListener.handleValue (dart:async/future_impl.dart:131)
#3      _Future._propagateToListeners.handleValueCallback (dart:async/future_impl.dart:637)
#4      _Future._propagateToListeners (dart:async/future_impl.dart:667)
#5      _Future._completeWithValue (dart:async/future_impl.dart:477)
#6      _Future._asyncComplete.<anonymous closure> (dart:async/future_impl.dart:528)
#7      _microtaskLoop (dart:async/schedule_microtask.dart:41)
#8      _startMicrotaskLoop (dart:async/schedule_microtask.dart:50)
#9      _runPendingImmediateCallback (dart:isolate-patch/isolate_patch.dart:96)
#10     _RawReceivePortImpl._handleMessage (dart:isolate-patch/isolate_patch.dart:149)

```
