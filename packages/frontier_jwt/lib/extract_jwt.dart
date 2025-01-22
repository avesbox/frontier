import 'package:frontier_strategy/frontier_strategy.dart';

const authHeader = 'authorization';

class ExtractJwt {

  static String? Function(StrategyRequest request) fromHeaders(String headerName) {
    return (request) => request.headers[headerName];
  }

  static String? Function(StrategyRequest request) fromQueryParams(String paramName) {
    return (request) => request.query[paramName];
  }

  static String? Function(StrategyRequest request) fromBody(String paramName) {
    return (request) {
      if(request.body is Map) {
        return request.body[paramName];
      }
      return null;
    };
  }

  static String? Function(StrategyRequest request) fromCookies(String cookieName) {
    return (request) => request.cookies[cookieName];
  }

  static String? Function(StrategyRequest request) fromAuthSchema(String schema) {
    final schemaLower = schema.toLowerCase();
    return (request) {
      final header = request.headers[authHeader];
      if(header == null) {
        return null;
      }
      final result = parseHeader(header);
      if(schemaLower != result?.schema?.toLowerCase()) {
        return null;
      }
      return result?.value;
    };
  }

  static String? Function(StrategyRequest request) fromAuthHeaderAsBearerToken(Map<String, String> headers) {
    return fromAuthSchema('bearer');
  }

}

({
  String? schema,
  String? value,
})? parseHeader(String header) {
  var re = RegExp(r'(\S+)\s+(\S+)');
  var match = re.firstMatch(header);
  if (match == null) {
    return null;
  }
  return (schema: match.group(1), value: match.group(2));
}