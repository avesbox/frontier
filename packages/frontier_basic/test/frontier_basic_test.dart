import 'package:frontier_basic/frontier_basic.dart';
import 'package:test/test.dart';

void main() {
  test('$BasicAuthStrategy', () async {
    final credentials = Credentials(username: 'test', password: 'test');
    final options = BasicAuthOptions();
    final strategy = BasicAuthStrategy(options, (options, credentials, done) async {
      done(credentials);
    });
    expect(strategy.name, 'BasicAuthentication');
    strategy.authenticate({'Authorization': 'dGVzdDp0ZXN0'});
    final result = await strategy.done.future;
    expect(result, equals(credentials));
  });
}
