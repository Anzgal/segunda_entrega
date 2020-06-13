import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/animation/ScaleRoute.dart';
import 'package:flutter_app/main.dart';
import '../providers/app.dart';
import '../providers/product.dart';
import '../providers/restaurant.dart';
import '../screens/ShopScreen.dart';
import '../widgets/loading.dart';
import '../widgets/product.dart';
import '../widgets/restaurant.dart';
import 'package:provider/provider.dart';

class RestaurantsSearchScreen extends StatelessWidget {

  @override
  Widget build(BuildContext mainContext) {
    final restaurantProvider = Provider.of<RestaurantProvider>(mainContext);
    final productProvider = Provider.of<ProductProvider>(mainContext);
    final app = Provider.of<AppProvider>(mainContext);
    GlobalKey _scaffold = GlobalKey();

    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(mainContext);
            }),
        title: Text("Tiendas", style: TextStyle(fontSize: 20),),

        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {})
        ],
      ),
      body: app.isLoading
          ? Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Loading()],
        ),
      )
          : restaurantProvider.searchedRestaurants.length < 1
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.search,
                color: Colors.grey,
                size: 30,
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("No se encontraron tiendas", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300, fontSize: 22),)

            ],
          )
        ],
      )
          : ListView.builder(
          itemCount: restaurantProvider.searchedRestaurants.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () async {
                  app.changeLoading();
                  await productProvider.loadProductsByRestaurant(
                      restaurantId: restaurantProvider.searchedRestaurants[index].id);
                  app.changeLoading();

                  Navigator.push(mainContext,ScaleRoute(page: RestaurantScreen(
                    restaurantModel: restaurantProvider.searchedRestaurants[index],
                  )));

                },
                child: RestaurantWidget(
                    restaurant:
                    restaurantProvider.searchedRestaurants[index]));
          }),
    );
  }
}