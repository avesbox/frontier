import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:frontier_jwt/extract_jwt.dart';
import 'package:frontier_strategy/frontier_strategy.dart';
import 'package:test/test.dart';
import 'package:frontier_jwt/jwt_strategy.dart';

void main() {
  group('$JwtStrategy', () {
    test('should have a name of jwt', () {
      final strategy = JwtStrategy(JwtStrategyOptions(
        SecretKey(''), jwtFromRequest: ExtractJwt.fromHeaders('auth')), (options, jwt, done) async {
          done(jwt);
        });
      expect(strategy.name, 'jwt');
    });

    test('should authenticate a token', () async {
      final strategy = JwtStrategy(JwtStrategyOptions(
        SecretKey('hello'),
        jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken()
      ), (options, jwt, done) async {
          done(jwt);
        });
      final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.ElsKKULlzGtesThefMuj2_a6KIY9L5i2zDrBLHV-e0M';
      strategy.authenticate(
        StrategyRequest(headers: {
          'Authorization': 'Bearer $token'
        })
      );
      final jwt = await strategy.future;
      expect(jwt, isA<JWT>());
    });

    test('should throw an error if the token is invalid', () async {
      final strategy = JwtStrategy(JwtStrategyOptions(
        SecretKey('hallo'),
        jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken()
      ), (options, jwt, done) async {
          done(jwt);
        });
      final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.ElsKKULlzGtesThefMuj2_a6KIY9L5i2zDrBLHV-e0M';
      strategy.authenticate(
        StrategyRequest(headers: {
          'Authorization': 'Bearer $token'
        })
      );
      final result = await strategy.future;
      expect(result, isA<JWTException>());
    });

    test('should parse header and return the schema and the value of the header', () {
      final r = parseHeader('Bearer token');
      expect(r?.value, 'token');
      expect(r?.schema, 'Bearer');
    });

    test('should return the value of the bearer header', () {
      final value = ExtractJwt.fromAuthHeaderAsBearerToken()(
        StrategyRequest(headers: {'authorization': 'Bearer token'})
      );
      expect(value, 'token');
      final value2 = ExtractJwt.fromAuthSchema('bearer')(
        StrategyRequest(headers: {'authorization': 'Bearer token'})
      );
      expect(value2, 'token');
    });

    test('should return the value of the header', () {
      final value = ExtractJwt.fromHeaders('authorization')(
        StrategyRequest(headers: {'authorization': 'Bearer token'})
      );
      expect(value, 'Bearer token');
    });

    test('should return the value of the query param', () {
      final value = ExtractJwt.fromQueryParams('token')(
        StrategyRequest(query: {'token': 'hello'})
      );
      expect(value, 'hello');
    });

    test('should return the value of the body param', () {
      final value = ExtractJwt.fromBody('token')(
        StrategyRequest(body: {'token': 'hello'})
      );
      expect(value, 'hello');
    });

    test('should return the value of the cookie', () {
      final value = ExtractJwt.fromCookies('token')(
        StrategyRequest(cookies: {'token': 'hello'})
      );
      expect(value, 'hello');
    });
  });
}
