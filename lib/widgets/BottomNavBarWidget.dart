import 'package:flutter/material.dart';
import 'package:flutter_app/screens/MapPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screens/homeScreen.dart';
import '../screens/FoodOrderPage.dart';
import '../screens/User.dart';
import 'package:flutter/services.dart';


class BottomNavBarWidget extends StatefulWidget {


  @override _BottomNavBarWidgetState createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {

  int index = 0;
  List<Widget> _widgets = [
    HomePage(),
    MapPage(),
    FoodOrderPage(),
    ProfilePage()
  ];
  tapped(int tappedIndex) {
    setState(() {
      index = tappedIndex;
      //navigateToScreens(index);
    });
  }
  @override
  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: _widgets[index],

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: index,
        selectedItemColor: Color(0xFFfd5352),
        onTap: tapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(
              'Inicio',
              style: TextStyle(color: Color(0xFF2c2b2b)),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.near_me),
            title: Text(
              'Cerca',
              style: TextStyle(color: Color(0xFF2c2b2b)),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            title: Text(
              'Carrito',
              style: TextStyle(color: Color(0xFF2c2b2b)),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user),
            title: Text(
              'Cuenta',
              style: TextStyle(color: Color(0xFF2c2b2b)),
            ),
          ),
        ],

      ),
    );
  }
}
