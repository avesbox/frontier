import 'package:frontier/frontier.dart';
import 'package:frontier_shelf/frontier_shelf.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

final Uri clientUri = Uri.parse('http://127.0.0.1:4322/');

final class HeaderOptions extends StrategyOptions {
  final String key;
  final String value;

  HeaderOptions(
      {required this.key, required this.value});
}

class HeaderStrategy extends Strategy<HeaderOptions, Map<String, dynamic>> {

  HeaderStrategy(super.options, super.callback);

  @override
  String get name => 'Header';

  @override
  Future<void> authenticate(Map<String, dynamic> headers) async {
    final value = headers[options.key] == options.value;
    callback.call(options, value, done.complete);
  }
}

void main() {
  group('test integration with Shelf', () {
    setUpAll(() {
      frontier.use(HeaderStrategy(HeaderOptions(key: 'hello', value: 'world'), (options, result, done) async {
        done(result);
      }));
    });
    test('test if the middleware goes through', () async {
      var handler = const Pipeline()
        .addMiddleware(frontierMiddleware('Header', (req) async => req.headers))
        .addHandler((req) => Response.ok('ok!'));

      final response = await handler(Request(
        'get', 
        clientUri,
        headers: {
          'hello': 'world'
        }
      ));

      expect(response.statusCode, 200);
    });

    test('test if the middleware should not go through', () async {
      var handler = const Pipeline()
        .addMiddleware(frontierMiddleware('Header', (req) async => req.headers))
        .addHandler((req) => Response.ok('ok!'));

      final response = await handler(Request(
        'get', 
        clientUri,
        headers: {
          'hello': ''
        }
      ));

      expect(response.statusCode, 401);
    });

    test('test if the middleware should not go through', () async {
      var handler = const Pipeline()
        .addMiddleware(frontierMiddleware('Header', (req) async => req.headers, unauthorizedMessage: 'Custom Message!'))
        .addHandler((req) => Response.ok('ok!'));

      final response = await handler(Request(
        'get', 
        clientUri,
        headers: {
          'hello': ''
        }
      ));
      final res = await response.readAsString();
      expect(res, 'Custom Message!');
    });
  });
}
