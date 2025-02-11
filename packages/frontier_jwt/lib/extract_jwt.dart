import 'package:frontier_strategy/frontier_strategy.dart';

/// The name of the header that contains the JWT
const authHeader = 'Authorization';

/// A function that extracts the JWT from a request
typedef ExtractJwtFunction = String? Function(StrategyRequest request);

/// A class that contains functions to extract the JWT from a request
class ExtractJwt {
  /// Extracts the JWT from the headers
  static String? Function(StrategyRequest request) fromHeaders(
      String headerName) {
    return (request) => request.headers[headerName];
  }

  /// Extracts the JWT from the query parameters
  static String? Function(StrategyRequest request) fromQueryParams(
      String paramName) {
    return (request) => request.query[paramName];
  }

  /// Extracts the JWT from the body
  static String? Function(StrategyRequest request) fromBody(String paramName) {
    return (request) {
      if (request.body is Map) {
        return request.body[paramName];
      }
      return null;
    };
  }

  /// Extracts the JWT from the cookies
  static String? Function(StrategyRequest request) fromCookies(
      String cookieName) {
    return (request) => request.cookies[cookieName];
  }

  /// Extracts the JWT from the headers using a schema
  static String? Function(StrategyRequest request) fromAuthSchema(
      String schema) {
    final schemaLower = schema.toLowerCase();
    return (request) {
      final header = request.headers[authHeader] ??
          request.headers[authHeader.toLowerCase()];
      if (header == null) {
        return null;
      }
      final result = parseHeader(header);
      if (schemaLower != result?.schema?.toLowerCase()) {
        return null;
      }
      return result?.value;
    };
  }

  /// Extracts the JWT from the headers using the 'bearer' schema
  static String? Function(StrategyRequest request)
      fromAuthHeaderAsBearerToken() {
    return fromAuthSchema('bearer');
  }
}

/// Parses a header that contains a schema and a value
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
