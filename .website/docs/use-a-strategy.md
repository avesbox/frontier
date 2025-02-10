# Use a Strategy

To use a strategy, you simply need to follow these steps:

```dart

import 'package:frontier/frontier.dart';

void main() async {
    final frontier = Frontier();
    frontier.use(MyStrategy(
        MyStrategyOptions(
            // Your strategy options
        ), 
        (options, result, done) async {
            // callback logic
        })
    );

    final result = await frontier.authenticate(
        'MyStrategy', // Strategy name
        StrategyRequest(
            // Add your request data here
        )
    );
}

```
