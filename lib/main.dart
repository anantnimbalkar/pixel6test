import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixel_test/provider/connectivity_provider.dart';
import 'package:pixel_test/provider/customer_provider.dart';
import 'package:pixel_test/screens/handler/connectivity_handler.dart';

import 'package:pixel_test/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(ChangeNotifierProvider(
        create: (context) => ConnectivityProvider(), child: const MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return ConnectivityHandler(
      child: ChangeNotifierProvider(
        create: (context) => CustomerProvider()..loadFromPrefs(),
        child: MaterialApp(
          theme: ThemeData(
            fontFamily: 'Sora',
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home:  SplashScreen(),
        ),
      ),
    );
  }
}
