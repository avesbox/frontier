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
  final Map<String, Strategy> _strategy = {};

  /// Create a new instance of Frontier.
  Frontier();

  /// Define a strategy to be used. If a strategy is already defined, an exception is thrown.
  void use<T extends StrategyOptions>(Strategy<T> strategy) {
    if (_strategy.containsKey(strategy.name)) {
      throw Exception('Strategy already defined');
    }
    _strategy[strategy.name] = strategy;
  }

  /// Authenticate using the defined strategy. If no strategy is defined, an exception is thrown.
  Future<dynamic> authenticate<T extends StrategyOptions>(String strategy, StrategyRequest input) async {
    if (!_strategy.containsKey(strategy)) {
      throw Exception('No strategy defined');
    }
    final s = _strategy[strategy];
    s?.done = Completer<Object?>();
    await s?.authenticate(input);
    return s?.done.future;
  }
}
