import 'package:flutter_app/providers/app.dart';
import 'package:flutter_app/providers/auth.dart';
import 'package:flutter_app/providers/category.dart';
import 'package:flutter_app/providers/product.dart';
import 'package:flutter_app/providers/restaurant.dart';
import 'package:flutter_app/screens/homeScreen.dart';
import 'package:flutter_app/screens/loginScreen.dart';
import 'package:flutter_app/screens/splashScreen.dart';
import 'package:flutter_app/widgets/BottomNavBarWidget.dart';
import 'package:flutter_app/widgets/loading.dart';
import 'package:provider/provider.dart';

import 'app.dart';

import 'package:flutter/material.dart';
//Punto de entrada para su aplicación
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //runApp(AppBasica());
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: AuthProvider.initialize()),
    ChangeNotifierProvider.value(value: CategoryProvider.initialize()),
    ChangeNotifierProvider.value(value: AppProvider()),
    ChangeNotifierProvider.value(value: RestaurantProvider.initialize()),
    ChangeNotifierProvider.value(value: ProductProvider.initialize()),


  ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), //  Tema Claro
//      theme: ThemeData.dark(), // Tema Obscuro
      home: ScreensController(),
    ),
  ));

}
class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    switch (auth.status) {
      case Status.Uninitialized:
        return Loading();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return SignInPage();
      case Status.Authenticated:
        return BottomNavBarWidget();
      default:
        return SignInPage();
    }
  }
}