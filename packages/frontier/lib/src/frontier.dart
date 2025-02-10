import 'dart:async';

import 'package:frontier_strategy/frontier_strategy.dart';

/// The main class of the library. It is used to define and use strategies.
/// 
/// ```dart
/// final frontier = Frontier();
/// 
/// frontier.use<GoogleStrategyOptions, User>(GoogleStrategy());
/// 
/// final user = await frontier.authenticate<GoogleStrategyOptions, User>(GoogleStrategyOptions());
/// 
/// print(user);
/// 
/// ```
/// 
class Frontier {
  final Map<String, Strategy> _strategies = {};

  /// Create a new instance of Frontier.
  Frontier();

  /// Define a strategy to be used. If a strategy is already defined, an exception is thrown.
  void use<T extends StrategyOptions>(Strategy<T> strategy) {
    final strategyName = strategy.name;
    if (_strategies.containsKey(strategyName)) {
      throw Exception('Strategy already defined');
    }
    _strategies[strategyName] = strategy;
  }

  /// Authenticate using the defined strategy. If no strategy is defined, an exception is thrown.
  Future<dynamic> authenticate<T extends StrategyOptions>(String strategy, StrategyRequest input) async {
    if (!_strategies.containsKey(strategy)) {
      throw ArgumentError('No strategy defined with the name $strategy');
    }
    final s = _strategies[strategy];
    s?.reset();
    await s?.authenticate(input);
    return s?.done;
  }
}
