# hello
threads: 20, connections: 200, duration: 10s
## Using library: `hypertext`
Running Dart code from `file:///Users/tobe/Source/Dart/hypertext_compare/bin/servers/hypertext/hello.dart`
### `wrk` results for `hypertext`
Running 10s test @ http://localhost:3000
  20 threads and 200 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    36.64ms   76.48ms 979.96ms   96.84%
    Req/Sec   396.46     76.16   505.00     80.55%
  75249 requests in 10.05s, 13.56MB read
  Socket errors: connect 0, read 187, write 0, timeout 0
Requests/sec:   7486.97
Transfer/sec:      1.35MB

### Total Time for `hypertext`:
15366322 ms
## Using library: `io`
Running Dart code from `file:///Users/tobe/Source/Dart/hypertext_compare/bin/servers/io/hello.dart`
ERROR: Server file:///Users/tobe/Source/Dart/hypertext_compare/bin/servers/io/hello.dart failed with: SocketException: Failed to create server socket (OS Error: The shared flag to bind() needs to be `true` if binding multiple times on the same (address, port) combination.), address = 127.0.0.1, port = 3000
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
### `wrk` results for `io`
Running 10s test @ http://localhost:3000
  20 threads and 200 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     0.00us    0.00us   0.00us     nan%
    Req/Sec     0.00      0.00     0.00       nan%
  0 requests in 10.10s, 0.00B read
  Socket errors: connect 0, read 190, write 0, timeout 0
Requests/sec:      0.00
Transfer/sec:       0.00B

### Total Time for `io`:
15260174 ms
