import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/helpers/order.dart';
import 'package:flutter_app/providers/app.dart';
import 'package:flutter_app/providers/auth.dart';
import 'package:provider/provider.dart';


import '../models/products.dart';
import '../providers/app.dart';
import '../providers/auth.dart';
import '../widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _key = GlobalKey<ScaffoldState>();
  OrderServices _orderServices = OrderServices();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context);
    final app = Provider.of<AppProvider>(context);



    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Carrito de compras"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: Colors.white,
      body: app.isLoading ? Loading() : ListView.builder(
          itemCount: user.userModel.cart.length,
          itemBuilder: (_, index) {
            print("THE PRICE IS: ${user.userModel.cart[index]["price"]}");
            print("THE QUANTITY IS: ${user.userModel.cart[index]["quantity"]}");

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.red.withOpacity(0.2),
                          offset: Offset(3, 2),
                          blurRadius: 30)
                    ]),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                      child: Image.network(
                        user.userModel.cart[index]["image"],
                        height: 120,
                        width: 140,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: user.userModel.cart[index]["name"] + "\n",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: "\$${user.userModel.cart[index]["price"] / 100} \n\n",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "Cantidad: ",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)),
                              TextSpan(
                                  text: user.userModel.cart[index]["quantity"].toString(),
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)),
                            ]),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: ()async{
                                app.changeLoading();
                                bool value = await user.removeFromCart(cartItem: user.userModel.cart[index]);
                                if(value){
                                  user.reloadUserModel();
                                  print("Agregado al carrito");
                                  _key.currentState.showSnackBar(
                                      SnackBar(content: Text("Eliminado del carrito"))
                                  );
                                  app.changeLoading();
                                  return;
                                }else{
                                  print("Error de eliminación");
                                  app.changeLoading();
                                }
                              })
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
      bottomNavigationBar: Container(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Total: ",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 22,
                          fontWeight: FontWeight.w400)),
                  TextSpan(
                      text: " \$${user.userModel.totalCartPrice / 100}",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 22,
                          fontWeight: FontWeight.normal)),
                ]),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: Colors.red),
                child: FlatButton(
                    onPressed: () {
                      if(user.userModel.totalCartPrice == 0){
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(20.0)), //this right here
                                child: Container(
                                  height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('Tu carrito está vacío', textAlign: TextAlign.center,),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                        return;
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(20.0)), //this right here
                              child: Container(
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Se te cobrará \$${user.userModel.totalCartPrice / 100} en la entrega', style: TextStyle(fontSize: 19),textAlign: TextAlign.center,),
                                      SizedBox(height: 30,),

                                      SizedBox(
                                        width: 320.0,
                                        child: RaisedButton(
                                          onPressed: () async{
                                            var uuid = Uuid();
                                            String id = uuid.v4();
                                            _orderServices.createOrder(
                                                userId: user.user.uid,
                                                id: id,
                                                description: "Descripción del pedido",
                                                status: "completado",
                                                totalPrice: user.userModel.totalCartPrice,
                                                cart: user.userModel.cart
                                            );
                                            for(Map cartItem in user.userModel.cart){
                                              bool value = await user.removeFromCart(cartItem: cartItem);
                                              if(value){
                                                user.reloadUserModel();
                                                print("Agregado al carrito");
                                                _key.currentState.showSnackBar(
                                                    SnackBar(content: Text("Eliminado del carrito"))
                                                );
                                              }else{
                                                print("Error de eliminación");
                                              }
                                            }
                                            _key.currentState.showSnackBar(
                                                SnackBar(content: Text("Orden creada"))
                                            );
                                            Navigator.pop(context);

                                          },
                                          child: Text(
                                            "Aceptar",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          color: Colors.green,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 320.0,
                                        child: RaisedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Cancelar",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            color: Colors.red
                                        ),
                                      )

                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: Text("Ordenar", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.normal),)
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}




















/*
class FoodOrderPage extends StatefulWidget {
  @override
  _FoodOrderPageState createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {
  final _key = GlobalKey<ScaffoldState>();
  OrderServices _orderServices = OrderServices();

  int counter = 3;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context);
    final app = Provider.of<AppProvider>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFAFAFA),
          elevation: 0,

          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF3a3737),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Center(
            child: Text(
              "Carrito de compras",
              style: TextStyle(
                  color: Color(0xFF3a3737),
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          brightness: Brightness.light,
          actions: <Widget>[
            CartIconWithBadge(),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    "Tu pedido",
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CartItem(
                    productName: "Coca-Cola 600ml",
                    productPrice: "\$12",
                    productImage: "Coca-Cola",
                    productCartQuantity: 2),
                SizedBox(
                  height: 10,
                ),
                CartItem(
                    productName: "Sabritas adobadas",
                    productPrice: "\$15",
                    productImage: "sabritas-adobadas",
                    productCartQuantity: 5),
                SizedBox(
                  height: 10,
                ),

                SizedBox(
                  height: 10,
                ),
                TotalCalculationWidget(),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    "Método de pago",
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                PaymentMethodWidget(),
                SizedBox(
                  height: 30,
                ),
                Center( child:FlatButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  //disabledColor: Colors.grey,
                  //disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(15.0),
                  splashColor: Colors.redAccent,
                  onPressed: () {
                    //Agregar
                  },
                  child: Text(
                    "Confirmar pedido",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ))
              ],
            ),
          ),
        ));
  }
}

class PaymentMethodWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFFfae3e2).withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ]),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 10, right: 30, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/menus/efectivo.png",
                  width: 50,
                  height: 50,
                ),
              ),
              Text(
                "Efectivo",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF3a3a3b),
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.left,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TotalCalculationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFFfae3e2).withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ]),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 25, right: 30, top: 10, bottom: 10),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Coca-Cola 600ml",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "\$15",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Sabritas adobadas",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "\$12",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "\$27",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class CartItem extends StatelessWidget {
  String productName;
  String productPrice;
  String productImage;
  int productCartQuantity;

  CartItem({
    Key key,
    @required this.productName,
    @required this.productPrice,
    @required this.productImage,
    @required this.productCartQuantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFFfae3e2).withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ]),
      child: Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Center(
                        child: Image.asset(
                      "assets/images/popular_foods/$productImage.png",
                      width: 110,
                      height: 100,
                    )),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "$productName",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF3a3a3b),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Text(
                                "$productPrice",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF3a3a3b),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                            "assets/images/menus/ic_delete.png",
                            width: 25,
                            height: 25,
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      alignment: Alignment.centerRight,
                      child: AddToCartMenu(productCartQuantity),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}

class CartIconWithBadge extends StatelessWidget {
  int counter = 7;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.business_center,
              color: Color(0xFF3a3737),
            ),
            onPressed: () {}),
        counter != 0
            ? Positioned(
                right: 11,
                top: 11,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    '$counter',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}

class AddToCartMenu extends StatelessWidget {
  int productCounter;

  AddToCartMenu(this.productCounter);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.remove),
            color: Colors.black,
            iconSize: 18,
          ),
          InkWell(
            onTap: () => print('hello'),
            child: Container(
              width: 100.0,
              height: 35.0,
              decoration: BoxDecoration(
                color: Color(0xFFfd2c2c),
                border: Border.all(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Center(
                child: Text(
                  'Piezas: $productCounter',
                  style: new TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
            color: Color(0xFFfd2c2c),
            iconSize: 18,
          ),
        ],
      ),
    );
  }
}
*/