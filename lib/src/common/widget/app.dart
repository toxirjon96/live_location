import 'package:flutter/material.dart';

import '../../features/pages/home_page/home_page.dart';
import '../constant/theme_config.dart';
import '../dependency/dependencies.dart';
import '../dependency/scope/dependency_scope.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.dependencies,
  });

  final Dependencies dependencies;

  void run() => runApp(this);

  @override
  Widget build(BuildContext context) {
    return DependencyScope(
      dependencies: dependencies,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Live Location',
            theme: ThemeConfig.theme,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
