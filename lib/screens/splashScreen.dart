import 'dart:async';

import 'package:flutter_app/providers/auth.dart';
import 'package:flutter_app/widgets/BottomNavBarWidget.dart';
import 'package:flutter_app/widgets/loading.dart';
import 'package:provider/provider.dart';

import 'loginScreen.dart';
import 'registerScreen.dart';
import 'package:flutter/material.dart';
import '../animation/ScaleRoute.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), _onShowLogin);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onShowLogin() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if(mounted){
      switch (auth.status){
        case Status.Uninitialized:
          Navigator.push(context, ScaleRoute(page: Loading()));
          break;
        case Status.Unauthenticated:
        case Status.Authenticating:
          Navigator.push(context, ScaleRoute(page: SignInPage()));
          break;
        case Status.Authenticated:
          Navigator.push(context, ScaleRoute(page: BottomNavBarWidget()));
          break;
        default: Navigator.push(context, ScaleRoute(page: SignInPage()));

      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[600],
      child: Column(
        children: <Widget>[
          SizedBox(height: 100.0,),
          Flexible(
            flex: 2,
            child: SafeArea(
              child: FractionallySizedBox(
                widthFactor: 0.7,
                child: Image.asset('assets/images/menus/tienditapp.png'),
              ),
            ),
          ),
          Text(
            'TienditApp',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          Flexible(
            flex: 2,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 16.0),
                alignment: Alignment.bottomCenter,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}