import 'package:flutter/material.dart';
import 'package:flutter_app/providers/app.dart';
import 'package:flutter_app/providers/auth.dart';
import 'package:flutter_app/providers/category.dart';
import 'package:flutter_app/providers/product.dart';
import 'package:flutter_app/providers/restaurant.dart';
import 'package:flutter_app/screens/FoodOrderPage.dart';
import 'package:flutter_app/screens/categoryScreen.dart';
import 'package:flutter_app/screens/productSearchScreen.dart';
import 'package:flutter_app/screens/restaurantSearchScreen.dart';
import 'package:flutter_app/widgets/featured_products.dart';
import 'package:flutter_app/widgets/loading.dart';
import 'package:flutter_app/widgets/restaurant.dart';
import 'package:provider/provider.dart';
import '../animation/ScaleRoute.dart';
import '../screens/loginScreen.dart';
import '../widgets/BestFoodWidget.dart';
import '../widgets/BottomNavBarWidget.dart';
import '../widgets/PopularFoodsWidget.dart';
import '../widgets/SearchWidget.dart';
import '../widgets/TopMenus.dart';
import 'ShopScreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final app = Provider.of<AppProvider>(context);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAFA),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        title: Image.asset(
          "assets/images/menus/tienditapp.png",
          height: 200,
          width: 200,
        ),
        brightness: Brightness.light,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Color(0xFF3a3737),
              ),
              onPressed: () {Navigator.push(context, ScaleRoute(page: CartScreen()));})
        ],

      ),
      body:  SafeArea(
    child: ListView(

          children: <Widget>[
            //Search widget
            //SearchWidget(),
            Padding(
              padding: const EdgeInsets.only(
                  top: 8, left: 8, right: 8, bottom: 10),
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
                    textInputAction: TextInputAction.search,
                    onSubmitted: (pattern)async{
                      app.changeLoading();
                      if(app.search == SearchBy.PRODUCTS){
                        await productProvider.search(productName: pattern);
                        Navigator.push(context,ScaleRoute(page: ProductSearchScreen()));
                      }else{
                        await restaurantProvider.search(name: pattern);
                        Navigator.push(context,ScaleRoute(page: RestaurantsSearchScreen()));
                      }
                      app.changeLoading();
                    },
                    decoration: InputDecoration(
                      hintText: "¿Qué quieres comprar hoy?",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("Buscar por:", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),),

                DropdownButton<String>(
                  value: app.filterBy,
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w300
                  ),
                  icon: Icon(Icons.filter_list,
                    color: Colors.red,),
                  elevation: 0,
                  onChanged: (value){
                    if (value == "Productos"){
                      app.changeSearchBy(newSearchBy: SearchBy.PRODUCTS);
                    }else{
                      app.changeSearchBy(newSearchBy: SearchBy.RESTAURANTS);
                    }
                  },
                  items: <String>["Productos", "Tiendas"].map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value));
                  }).toList(),

                ),
              ],
            ),

            //End search






            //Categories

            Container(
              height: 100,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryProvider.categories.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
//                              app.changeLoading();
                        await productProvider.loadProductsByCategory(
                            categoryName:
                            categoryProvider.categories[index].name);

                        Navigator.push(context, ScaleRoute(page: CategoryScreen(
                          categoryModel:
                          categoryProvider.categories[index],
                        )));


//                              app.changeLoading();

                      },
                      child: CategoryWidget(
                        category: categoryProvider.categories[index],
                      ),
                    );
                  }),
            ),

            //End categories


            //Productos populares
            //PopularFoodsWidget(),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Productos Populares",
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            Featured(),




            //End productos populares


            // Tiendas
            //BestFoodWidget(),

          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Tiendas Populares",
                  style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF3a3a3b),
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
            Column(
              children: restaurantProvider.restaurants
                  .map((item) => GestureDetector(
                onTap: () async {
                  app.changeLoading();

                  await productProvider.loadProductsByRestaurant(
                      restaurantId: item.id);
                  app.changeLoading();


                  Navigator.push(context, ScaleRoute(page: RestaurantScreen(
                    restaurantModel: item,
                  )));
                },
                child: RestaurantWidget(
                  restaurant: item,
                ),
              ))
                  .toList(),
            )







            //End tiendas
          ],
        ),
      ),
      //bottomNavigationBar: BottomNavBarWidget(),

    );
  }
}
