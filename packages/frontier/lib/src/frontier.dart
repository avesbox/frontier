import 'package:frontier_strategy/frontier_strategy.dart';

class Frontier {

  Strategy? _strategy;

  Frontier();

  void use<T extends StrategyOptions>(Strategy<T> strategy) {
    if(_strategy != null){
      throw Exception('Strategy already defined');
    }
    _strategy = strategy;
  }

  Future<bool> authenticate<T extends StrategyOptions>(T options) async {
    if(_strategy == null) {
      return true;
    }
    return await _strategy?.authenticate(options) ?? false;
  }

}