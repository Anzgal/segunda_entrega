import 'package:flutter/material.dart';
import 'package:flutter_app/animation/ScaleRoute.dart';
import '../providers/product.dart';
import '../screens/FoodDetailsPage.dart';
import '../widgets/product.dart';
import 'package:provider/provider.dart';

class ProductSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.close), onPressed: (){
          Navigator.pop(context);
        }),
        title: Text("Productos", style: TextStyle(fontSize: 20),),
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){})
        ],
      ),
      body: productProvider.productsSearched.length < 1? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.search, color: Colors.grey, size: 30,),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("No se encontraron productos", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300, fontSize: 22),),
            ],
          )
        ],
      ) : ListView.builder(
          itemCount: productProvider.productsSearched.length,
          itemBuilder: (context, index){
            return GestureDetector(
                onTap: ()async{
                  Navigator.push(context,ScaleRoute(page: Details(product: productProvider.productsSearched[index])));

                },
                child: ProductWidget(product: productProvider.productsSearched[index]));
          }),
    );
  }
}