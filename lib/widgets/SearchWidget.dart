import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/auth.dart';


class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Padding(
      padding: EdgeInsets.only(left: 10,top: 5,right: 10,bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: Icon(
            Icons.search,
            color: Colors.red,
          ),
          title: TextField(
            decoration: InputDecoration(
              hintText: "¿Qué deseas comprar hoy?",

              border: InputBorder.none,
            ),
          ),
          trailing: Icon(
            Icons.filter_list,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
