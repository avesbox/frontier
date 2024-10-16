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
  Strategy? _strategy;

  /// Create a new instance of Frontier.
  Frontier();

  /// Define a strategy to be used. If a strategy is already defined, an exception is thrown.
  void use<T extends StrategyOptions, I, R>(Strategy<T, I, R> strategy) {
    if (_strategy != null) {
      throw Exception('Strategy already defined');
    }
    _strategy = strategy;
  }

  /// Authenticate using the defined strategy. If no strategy is defined, an exception is thrown.
  Future<R> authenticate<T extends StrategyOptions, I, R>(I input) async {
    if (_strategy == null) {
      throw Exception('No strategy defined');
    }
    return (await _strategy?.authenticate(input)) as R;
  }
}
