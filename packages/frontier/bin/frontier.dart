import 'package:frontier/frontier.dart';
import 'dart:io';

final class HeaderOptions extends StrategyOptions {
  final String key;
  final String value;

  HeaderOptions(
      {required this.key, required this.value});
}

class HeaderStrategy implements Strategy<HeaderOptions, Map<String, dynamic>, bool> {

  const HeaderStrategy(this.options);

  @override
  String get name => 'Header';

  @override
  Future<bool> authenticate(Map<String, dynamic> headers) async {
    return headers[options.key] == options.value;
  }
  
  @override
  final HeaderOptions options;
}

void main(List<String> arguments) {
  Frontier frontier = Frontier();
  frontier.use(HeaderStrategy(HeaderOptions(key: 'auth', value: 'admin')));
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
            (options, result) async {
              if (result) {
                request.response.write('Authenticated');
              } else {
                request.response.statusCode = HttpStatus.unauthorized;
                request.response.write('Not Authenticated');
              }
              request.response.close();
            }
          );
    });
  });
}
