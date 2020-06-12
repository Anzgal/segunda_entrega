import 'package:flutter/material.dart';
import '../helpers/restaurant.dart';
import '../models/tienda.dart';

class RestaurantProvider with ChangeNotifier{
  RestaurantServices _restaurantServices = RestaurantServices();
  List<TiendaModel> restaurants = [];
  List<TiendaModel> searchedRestaurants = [];

  TiendaModel restaurant;

  RestaurantProvider.initialize(){
    loadRestaurants();
  }

  loadRestaurants()async{
    restaurants = await _restaurantServices.getRestaurants();
    notifyListeners();
  }

  loadSingleRestaurant({int retaurantId}) async{
    restaurant = await _restaurantServices.getRestaurantById(id: retaurantId);
    notifyListeners();
  }

  Future search({String name})async{
    searchedRestaurants = await _restaurantServices.searchRestaurant(restaurantName: name);
    print("RESTOS ARE: ${searchedRestaurants.length}");
    notifyListeners();
  }
}