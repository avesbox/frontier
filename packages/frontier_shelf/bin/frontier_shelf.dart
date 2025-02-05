import 'package:frontier/frontier.dart';
import 'package:frontier_shelf/frontier_shelf.dart' as frontier_shelf;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

final class HeaderOptions extends StrategyOptions {
  final String key;
  final String value;

  HeaderOptions(
      {required this.key, required this.value});
}

class HeaderStrategy extends Strategy<HeaderOptions> {

  HeaderStrategy(super.options, super.callback);

  @override
  String get name => 'Header';

  @override
  Future<void> authenticate(StrategyRequest request) async {
    final value = request.headers[options.key] == options.value;
    callback.call(options, value, done.complete);
  }
}

void main(List<String> arguments) async {
  frontier_shelf.frontier.use(HeaderStrategy(HeaderOptions(key: 'hello', value: 'world'), (options, result, done) async {
    done(result);
  }));
  var handler = const Pipeline()
            .addMiddleware(frontier_shelf.frontierMiddleware('Header', (req) async => StrategyRequest(headers: req.headers)))
            .addHandler((req) => Response.ok('ok!'));

    await serve(handler, '0.0.0.0', 3000);
}
