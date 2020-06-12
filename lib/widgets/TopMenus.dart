import 'package:flutter/material.dart';
import 'package:flutter_app/animation/ScaleRoute.dart';
import 'package:flutter_app/models/category.dart';
import 'package:flutter_app/providers/auth.dart';
import 'package:flutter_app/providers/category.dart';
import 'package:flutter_app/providers/product.dart';
import 'package:flutter_app/screens/categoryScreen.dart';
import 'package:provider/provider.dart';
import 'loading.dart';
import 'package:transparent_image/transparent_image.dart';


class TopMenus extends StatefulWidget {
  @override
  _TopMenusState createState() => _TopMenusState();
}

class _TopMenusState extends State<TopMenus> {
  @override
  Widget build(BuildContext context) {

    final categoryProvider = Provider.of<CategoryProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);


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
    );
  }
}

class TopMenuTiles extends StatelessWidget {
  String name;
  String imageUrl;
  String slug;

  TopMenuTiles(
      {Key key,
      @required this.name,
      @required this.imageUrl,
      @required this.slug})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
            decoration: new BoxDecoration(boxShadow: [
              new BoxShadow(
                color: Color(0xFFfae3e2),
                blurRadius: 25.0,
                offset: Offset(0.0, 0.75),
              ),
            ]),
            child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(3.0),
                  ),
                ),
                child: Container(
                  width: 50,
                  height: 50,
                  child: Center(
                      child: Image.asset(
                    'assets/images/topmenu/' + imageUrl + ".png",
                    width: 24,
                    height: 24,
                  )),
                )),
          ),
          Text(name,
              style: TextStyle(
                  color: Color(0xFF6e6e71),
                  fontSize: 14,
                  fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}



class CategoryWidget extends StatelessWidget {
  final CategoryModel category;

  const CategoryWidget({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(6),
    child: Stack(
    children: <Widget>[
    Container(
    width: 140,
    height: 160,
    child: ClipRRect(
    borderRadius: BorderRadius.circular(30),
    child: Stack(
    children: <Widget>[
    Positioned.fill(child: Align(
    alignment: Alignment.center,
    child: Loading(),
    )),
    Center(
    child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: category.image),
    )
    ],
    )),
    ),

    Container(
    width: 140,
    height: 160,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.only(
    bottomLeft: Radius.circular(30),
    bottomRight: Radius.circular(30),
    ),
    gradient: LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
    Colors.black.withOpacity(0.6),
    Colors.black.withOpacity(0.6),
    Colors.black.withOpacity(0.6),
    Colors.black.withOpacity(0.4),
    Colors.black.withOpacity(0.1),
    Colors.black.withOpacity(0.05),
    Colors.black.withOpacity(0.025),
    ],
    )),
    ),

    Positioned.fill(
    child: Align(
    alignment: Alignment.center,
    child: Text(
    category.name,
    style: TextStyle(
    color: Colors.white,
    fontSize: 26,
    fontWeight: FontWeight.w300
    ) ,
    )))
    //CustomText(text: category.name, color: white, size: 26, weight: FontWeight.w300,)))
    ],
    ),
    );
  }
}
