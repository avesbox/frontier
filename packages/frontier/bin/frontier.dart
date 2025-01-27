import 'package:frontier/frontier.dart';
import 'dart:io';

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
    callback.call(options, headers[options.key] == options.value, done.complete);
  }
}

void main(List<String> arguments) {
  Frontier frontier = Frontier();
  frontier.use(HeaderStrategy(HeaderOptions(key: 'auth', value: 'admin'), (options, result, done) async {
              done(result);
            }));
  HttpServer.bind(InternetAddress.loopbackIPv4, 8080).then((server) {
    server.listen((HttpRequest request) {
      final headers = <String, dynamic>{};
      request.headers.forEach((key, values) {
        headers[key] = values.join(',');
      });
      frontier
          .authenticate(
            'Header',
              headers,
          );
    });
  });
}
