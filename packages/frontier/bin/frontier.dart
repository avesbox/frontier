import 'package:frontier/frontier.dart';
import 'dart:io';

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
    callback.call(options, request.headers[options.key] == options.value, done.complete);
  }
}

void main(List<String> arguments) {
  Frontier frontier = Frontier();
  frontier.use(HeaderStrategy(HeaderOptions(key: 'auth', value: 'admin'), (options, result, done) async {
              done(result);
            }));
  HttpServer.bind(InternetAddress.loopbackIPv4, 8080).then((server) {
    server.listen((HttpRequest request) {
      final headers = <String, String>{};
      request.headers.forEach((key, values) {
        headers[key] = values.join(',');
      });
      frontier
          .authenticate(
            'Header',
              StrategyRequest(headers: headers),
          );
    });
  });
}
