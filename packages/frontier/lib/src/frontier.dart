import 'package:frontier_strategy/frontier_strategy.dart';

class Frontier {
  Strategy? _strategy;

  Frontier();

  void use<T extends StrategyOptions, R>(Strategy<T, R> strategy) {
    if (_strategy != null) {
      throw Exception('Strategy already defined');
    }
    _strategy = strategy;
  }

  Future<R> authenticate<T extends StrategyOptions, R>(T options) async {
    return (await _strategy?.authenticate(options)) as R;
  }
}
