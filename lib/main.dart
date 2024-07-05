import 'package:flutter/material.dart';
import 'package:musikalitas/pages/splash_screen.dart';
import 'pages/home_page.dart'; // Import HomePage

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      navigatorObservers: [routeObserver],
    );
  }
}
