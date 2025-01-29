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
    test('when the header value in the request is correct it should pass through the middleware', () async {
      var handler = const Pipeline()
        .addMiddleware(frontierMiddleware('Header', (req) async => req.headers))
        .addHandler((req) => Response.ok('ok!', context: req.context));
      final req = Request(
        'get', 
        clientUri,
        headers: {
          'hello': 'world'
        }
      );
      final response = await handler(req);
      expect(response.context['frontier.Header'], equals(true));
      expect(response.statusCode, 200);
    });

    test('when the header value in the request is not correct it should not pass through the middleware', () async {
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

    test('when on error and the message is changed by the "unauthorizedMessage" the custom message should be sent instead of the default one', () async {
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
