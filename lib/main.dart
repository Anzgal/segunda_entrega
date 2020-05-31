import 'package:flutter_app/providers/auth.dart';
import 'package:flutter_app/screens/splashScreen.dart';
import 'package:provider/provider.dart';

import 'app.dart';

import 'package:flutter/material.dart';
//Punto de entrada para su aplicación
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //runApp(AppBasica());
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: AuthProvider.initialize())
  ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), //  Tema Claro
//      theme: ThemeData.dark(), // Tema Obscuro
      home: SplashScreen(),
    ),
  ));
}