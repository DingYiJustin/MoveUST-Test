import 'package:flutter/material.dart';
import 'home.dart';
import 'routes.dart' as routes;


String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}





void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: routes.initialRoute,
      onGenerateRoute: routes.Router.generateRoute,
    );
  }
}
