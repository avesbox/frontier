import 'package:frontier/frontier.dart';
import 'dart:io';

final class HeaderOptions extends StrategyOptions {

  final String key;
  final String value;
  final Map<String, dynamic> headers;

  HeaderOptions({
    required this.key,
    required this.value,
    required this.headers
  });

}

class HeaderStrategy implements Strategy<HeaderOptions> {

  @override
  String get name => 'Header';

  @override
  Future<bool> authenticate(HeaderOptions options) async {
    return options.headers[options.key] == options.value;
  }
  
}


void main(List<String> arguments) {
  Frontier frontier = Frontier();
  frontier.use(HeaderStrategy());
  HttpServer.bind(InternetAddress.loopbackIPv4, 8080).then((server) {
    server.listen((HttpRequest request) {
      final headers = <String, dynamic>{};
      request.headers.forEach((key, values) {
        headers[key] = values.join(',');
      });
      frontier.authenticate(HeaderOptions(key: 'auth', value: 'admin', headers: headers)).then((authenticated) {
        if(authenticated) {
          request.response.write('Authenticated');
        } else {
          request.response.statusCode = HttpStatus.unauthorized;
          request.response.write('Not Authenticated');
        }
        request.response.close();
      });
    });
  });

}
