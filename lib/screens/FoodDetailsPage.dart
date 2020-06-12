import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/animation/ScaleRoute.dart';
import '../models/products.dart';
import '../providers/app.dart';
import '../providers/auth.dart';
import '../widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'FoodOrderPage.dart';



class Details extends StatefulWidget {
  final ProductModel product;

  const Details({@required this.product});


  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int quantity = 1;
  final _key = GlobalKey<ScaffoldState>();

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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {

              Navigator.push(context, ScaleRoute(page: CartScreen()));
            },
          ),

        ],
        leading: IconButton(icon: Icon(Icons.close), onPressed: (){Navigator.pop(context);}),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: app.isLoading ? Loading() : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 120,
              backgroundImage: NetworkImage(widget.product.image),
            ),
            SizedBox(height: 15,),


            Text(widget.product.name, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
            Text("\$${widget.product.price / 100}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

            SizedBox(height: 10,),
            Text("Tienda: " + widget.product.restaurant, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),),

            SizedBox(height: 10,),
            Text("Descripción", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),



            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.product.description , textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),),
            ),






            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(icon: Icon(Icons.remove,size: 36,), onPressed: (){
                    if(quantity != 1){
                      setState(() {
                        quantity -= 1;
                      });
                    }
                  }),
                ),

                GestureDetector(
                  onTap: ()async{
                    app.changeLoading();
                    print("All set loading");

                    bool value =  await user.addToCard(product: widget.product, quantity: quantity);
                    if(value){
                      print("Agregado al carrito");
                      _key.currentState.showSnackBar(
                          SnackBar(content: Text("Agregado al carrito"))
                      );
                      user.reloadUserModel();
                      app.changeLoading();
                      return;
                    } else{
                      print("No se agregó el carrito");

                    }

                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: app.isLoading ? Loading() : Padding(
                      padding: const EdgeInsets.fromLTRB(28,12,28,12),
                      child: Text("Agregar $quantity al carrito", style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.w300),),

                    ),

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(icon: Icon(Icons.add,size: 36,color: Colors.red,), onPressed: (){
                    setState(() {
                      quantity += 1;
                    });
                  }),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}