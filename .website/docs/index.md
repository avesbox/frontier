# Getting Started

To get started with Frontier you simply need to use the command below to add the dependency to your project:

```bash
dart pub add frontier
```

After adding the dependency you can start using Frontier in your project. Below you can see an example of how to use Frontier:

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
