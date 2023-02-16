import 'package:flutter/material.dart';
import 'package:flutter_application_1/UI/RedemptionScreen/RedemptionPage.dart';

import 'home.dart';

const String initialRoute = 'redemption';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'home':
        return MaterialPageRoute(builder: (_) => const Home());
      case 'redemption':
        return MaterialPageRoute(builder: (_) => const RedemptionPage());
      default:

        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text('Cannot find ${settings.name}'),
              ),
            ));
    }
  }
}
