import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screens/homeScreen.dart';
import '../screens/FoodOrderPage.dart';
import '../screens/User.dart';

class BottomNavBarWidget extends StatefulWidget {

  @override _BottomNavBarWidgetState createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  int index = 0;
  List<Widget> _widgets = [
    HomePage(),
    HomePage(),
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
              'Home',
              style: TextStyle(color: Color(0xFF2c2b2b)),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.near_me),
            title: Text(
              'Near By',
              style: TextStyle(color: Color(0xFF2c2b2b)),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            title: Text(
              'Cart',
              style: TextStyle(color: Color(0xFF2c2b2b)),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user),
            title: Text(
              'Account',
              style: TextStyle(color: Color(0xFF2c2b2b)),
            ),
          ),
        ],

      ),
    );
  }
}
