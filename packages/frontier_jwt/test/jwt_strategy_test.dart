import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:frontier_jwt/extract_jwt.dart';
import 'package:test/test.dart';
import 'package:frontier_jwt/jwt_strategy.dart';

void main() {
  group('$JwtStrategy', () {
    test('should have a name of jwt', () {
      final strategy = JwtStrategy(JwtStrategyOptions(secret: SecretKey('')));
      expect(strategy.name, 'jwt');
    });

    test('should authenticate a token', () async {
      final strategy = JwtStrategy(JwtStrategyOptions(secret: SecretKey('hello')));
      final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.ElsKKULlzGtesThefMuj2_a6KIY9L5i2zDrBLHV-e0M';
      final jwt = await strategy.authenticate(token);
      expect(jwt, isA<JWT>());
    });

    test('should throw an error if the token is invalid', () async {
      final strategy = JwtStrategy(JwtStrategyOptions(secret: SecretKey('hella')));
      final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.ElsKKULlzGtesThefMuj2_a6KIY9L5i2zDrBLHV-e0M';
      expect(strategy.authenticate(token), throwsA(isA<JWTException>()));
    });

    test('test parse headeer', () {
      final r = parseHeader('Bearer token');
      expect(r?.value, 'token');
      expect(r?.schema, 'Bearer');
    });
  });
}
