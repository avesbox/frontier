library frontier_basic;

import 'dart:convert';

import 'package:frontier_strategy/frontier_strategy.dart';

final class BasicAuthOptions extends StrategyOptions {

  /// The header to look for in the request
  /// 
  /// By default this is set to 'Authorization', but can be changed
  final String header;

  /// A fallback header to use if the header is not found
  /// 
  /// By default this is set to 'Proxy-Authorization', but can be changed
  final String proxyHeader;

  /// The headers of the request in the form of a map
  /// Both the key and value are strings
  final Map<String, String> headers;
  
  /// The credentials to compare against
  final Credentials credentials;

  BasicAuthOptions({
    required this.credentials,
    required this.headers,
    this.header = 'Authorization',
    this.proxyHeader = 'Proxy-Authorization',
  });

}

final class Credentials {
  final String username;
  final String password;

  Credentials({required this.username, required this.password});
}

class BasicAuthStrategy implements Strategy<BasicAuthOptions, bool> {
  @override
  String get name => 'BasicAuthentication';

  @override
  Future<bool> authenticate(BasicAuthOptions options) async {
    if(options.headers.containsKey(options.header)) {
      return _decode(options.headers[options.header]!, options.credentials);
    } else if(options.headers.containsKey(options.proxyHeader)) {
      return _decode(options.headers[options.proxyHeader]!, options.credentials);
    } else {
      return false;
    }
  }

  bool _decode(String value, Credentials credentials) {
    final decoded = utf8.decode(base64.decode(value));
    final parts = decoded.split(':');
    if(parts.length != 2) {
      return false;
    }
    return parts[0] == credentials.username && parts[1] == credentials.password;
  }
}
