import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/animation/ScaleRoute.dart';
import 'package:flutter_app/providers/auth.dart';
import '../models/products.dart';
import '../providers/product.dart';
import '../providers/auth.dart';
import '../screens/FoodDetailsPage.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'loading.dart';

class Featured extends StatefulWidget {
  @override
  _FeaturedState createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final user = Provider.of<AuthProvider>(context);


    return Container(
      height: 220,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: productProvider.products.length,
          itemBuilder: (_, index) {
            return Padding(
                padding: EdgeInsets.fromLTRB(12, 14, 16, 12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(_, ScaleRoute(page: Details(product: productProvider.products[index],)
                    )
                    );

                  },
                  child: Container(
                    height: 220,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[300],
                              offset: Offset(-2, -1),
                              blurRadius: 5),
                        ]),
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Loading(),
                                  )),
                              Center(
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: productProvider.products[index].image,
                                  height: 126,
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(productProvider.products[index].name ??
                                  "id null",),

                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: GestureDetector(
                                onTap: (){
//                                  setState(() {
//                                    productProvider.products[index].liked = !productProvider.products[index].liked;
//                                  });
//                                  productProvider.likeDislikeProduct(userId: user.userModel.id, product: productProvider.products[index], liked: productProvider.products[index].liked);
                                },
                                child: Container(),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(productProvider.products[index].rating
                                      .toString(), style: TextStyle(color: Colors.grey, fontSize: 14),),

                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.red,
                                  size: 16,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.red,
                                  size: 16,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.red,
                                  size: 16,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text("\$${productProvider.products[index].price / 100}", style: TextStyle(fontWeight: FontWeight.bold),),

                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ));
          }),
    );
  }
}