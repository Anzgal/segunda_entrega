import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tienda.dart';

class RestaurantServices {
  String collection = "restaurants";
  Firestore _firestore = Firestore.instance;

  Future<List<TiendaModel>> getRestaurants() async =>
      _firestore.collection(collection).getDocuments().then((result) {
        List<TiendaModel> restaurants = [];
        for(DocumentSnapshot restaurant in result.documents){
          restaurants.add(TiendaModel.fromSnapshot(restaurant));
        }
        return restaurants;
      });

  Future<TiendaModel> getRestaurantById({int id}) => _firestore.collection(collection).document(id.toString()).get().then((doc){
    return TiendaModel.fromSnapshot(doc);
  });

  Future<List<TiendaModel>> searchRestaurant({String restaurantName}) {
    // code to convert the first character to uppercase
    String searchKey = restaurantName[0].toUpperCase() + restaurantName.substring(1);
    return _firestore
        .collection(collection)
        .orderBy("name")
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .getDocuments()
        .then((result) {
      List<TiendaModel> restaurants = [];
      for (DocumentSnapshot product in result.documents) {
        restaurants.add(TiendaModel.fromSnapshot(product));
      }
      return restaurants;
    });
  }
}