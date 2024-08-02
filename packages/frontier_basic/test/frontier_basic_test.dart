import 'package:frontier_basic/frontier_basic.dart';
import 'package:test/test.dart';

void main() {
  test('$BasicAuthStrategy', () {
    final credentials = Credentials(username: 'test', password: 'test');
    final options = BasicAuthOptions(
      credentials: credentials,
      headers: {'Authorization': 'dGVzdDp0ZXN0'},
    );
    final strategy = BasicAuthStrategy();
    expect(strategy.name, 'BasicAuthentication');
    expect(strategy.authenticate(options), true);
  });
}
