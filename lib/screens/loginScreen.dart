import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/providers/auth.dart';
import 'package:flutter_app/widgets/loading.dart';
import 'package:provider/provider.dart';
import '../animation/ScaleRoute.dart';
import '../screens/homeScreen.dart';
import '../screens/registerScreen.dart';
import '../widgets/BottomNavBarWidget.dart';


class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      key: _key,
      body: authProvider.status == Status.Authenticating? Loading(): Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 35, bottom: 30),
        width: double.infinity,
        height: double.infinity,
        color: Colors.white70,
        child: Column(
          children: <Widget>[

            Flexible(
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 230,
                    height: 100,
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/menus/tienditapp.png",
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: authProvider.email,
                    showCursor: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color(0xFF666666),
                        size: defaultIconSize,
                      ),
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "Correo",
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: authProvider.password,
                    showCursor: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Color(0xFF666666),
                        size: defaultIconSize,
                      ),
                      suffixIcon: Icon(
                        Icons.remove_red_eye,
                        color: Color(0xFF666666),
                        size: defaultIconSize,
                      ),
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                        color: Color(0xFF666666),
                        fontFamily: defaultFontFamily,
                        fontSize: defaultFontSize,
                      ),
                      hintText: "Contraseña",
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),

          //ButtonWidget
          GestureDetector(
            onTap: ()async{
              if(!await authProvider.signIn()){
                _key.currentState.showSnackBar(
                  SnackBar(content: Text("Error de inicio de seión"))
                );
                return;
              }
              authProvider.clearController();
              Navigator.push(context, ScaleRoute(page: BottomNavBarWidget()));
            },
            child: Container(

              width: double.infinity,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color(0xFFfbab66),
                  ),
                  BoxShadow(
                    color: Color(0xFFf7418c),
                  ),
                ],
                gradient: new LinearGradient(
                    colors: [Colors.red, Colors.yellow],
                    begin: const FractionalOffset(0.2, 0.2),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Color(0xFFf7418c),
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      "Iniciar sesión",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontFamily: "WorkSansBold"),
                    ),
                  ),
                  //onPressed: () => {Navigator.push(context, ScaleRoute(page: BottomNavBarWidget()))}
                ),

            ),
          ),
                  SizedBox(
                    height: 2,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "¿Todavía no tienes una cuenta? ",
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => {
                        Navigator.push(context, ScaleRoute(page: SignUpPage()))
                      },
                      child: Container(
                        child: Text(
                          "Regístrate",
                          style: TextStyle(
                            color: Color(0xFFf7418c),
                            fontFamily: defaultFontFamily,
                            fontSize: defaultFontSize,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}



