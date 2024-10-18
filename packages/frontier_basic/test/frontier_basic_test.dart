import 'package:frontier_basic/frontier_basic.dart';
import 'package:test/test.dart';

void main() {
  test('$BasicAuthStrategy', () {
    final credentials = Credentials(username: 'test', password: 'test');
    final options = BasicAuthOptions(
      credentials: credentials,
    );
    final strategy = BasicAuthStrategy(options);
    expect(strategy.name, 'BasicAuthentication');
    expect(strategy.authenticate({'Authorization': 'dGVzdDp0ZXN0'}), true);
  });
}
