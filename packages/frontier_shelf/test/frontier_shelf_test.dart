import 'package:frontier/frontier.dart';
import 'package:frontier_shelf/frontier_shelf.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

final Uri clientUri = Uri.parse('http://127.0.0.1:4322/');

final class HeaderOptions extends StrategyOptions {
  final String key;
  final String value;

  HeaderOptions({required this.key, required this.value});
}

class HeaderStrategy extends Strategy<HeaderOptions> {
  HeaderStrategy(super.options, super.callback);

  @override
  String get name => 'Header';

  @override
  Future<void> authenticate(StrategyRequest request) async {
    final value = request.headers[options.key] == options.value;
    callback.call(options, value, done);
  }
}

void main() {
  group('test integration with Shelf', () {
    setUpAll(() {
      frontier.use(HeaderStrategy(HeaderOptions(key: 'hello', value: 'world'),
          (options, result, done) async {
        done(result);
      }));
    });
    test(
        'if the request contains the right header the request should go through and the context should be modified',
        () async {
      var handler = const Pipeline()
          .addMiddleware(frontierMiddleware(
              'Header', (req) async => StrategyRequest(headers: req.headers)))
          .addHandler((req) => Response.ok('ok!', context: req.context));
      final req = Request('get', clientUri, headers: {'hello': 'world'});
      final response = await handler(req);
      expect(response.context['frontier.Header'], equals(true));
      expect(response.statusCode, 200);
      expect(response.context['frontier.Header'], true);
    });

    test(
        'if the request does not contain the right header the request should not go through with a 401 status code',
        () async {
      var handler = const Pipeline()
          .addMiddleware(frontierMiddleware(
              'Header', (req) async => StrategyRequest(headers: req.headers)))
          .addHandler((req) => Response.ok('ok!'));

      final response =
          await handler(Request('get', clientUri, headers: {'hello': ''}));

      expect(response.statusCode, 401);
    });

    test(
        'if the request does not contain the right header the request and custom message is passed the request should not go through with the custom message in the response.',
        () async {
      var handler = const Pipeline()
          .addMiddleware(frontierMiddleware(
              'Header', (req) async => StrategyRequest(headers: req.headers),
              unauthorizedMessage: 'Custom Message!'))
          .addHandler((req) => Response.ok('ok!'));

      final response =
          await handler(Request('get', clientUri, headers: {'hello': ''}));
      final res = await response.readAsString();
      expect(res, 'Custom Message!');
    });
  });
}
