import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  static const NAME = "name";
  static const LAST = "last";
  static const EMAIL = "email";
  static const PHONE = "phone";
  static const ID = "id";
  static const ZIP = "zip";
  static const ADDRESS = "address";
  static const CART = "cart";
  static const STRIPE_ID = "stripeId";


  String _name;
  String _last;
  String _email;
  String _phone;
  String _id;
  int _zip;
  String _address;
  int _priceSum = 0;
  int _quantitySum = 0;
  String _stripeId;


  String get name => _name;
  String get last => _last;
  String get email => _email;
  String get phone => _phone;
  String get id => _id;
  int get zip => _zip;
  String get address => _address;
  String get stripeId => _stripeId;


  List cart;
  int totalCartPrice;

  UserModel.fromSnapshot(DocumentSnapshot snapshot){
    _name = snapshot.data[NAME];
    _last = snapshot.data[LAST];
    _email = snapshot.data[EMAIL];
    _phone = snapshot.data[PHONE];
    _id = snapshot.data[ID];
    _zip = snapshot.data[ZIP];
    _address = snapshot.data[ADDRESS];
    _stripeId = snapshot.data[STRIPE_ID];
    cart = snapshot.data[CART] ?? [];
    totalCartPrice = snapshot.data[CART] == null ? 0 :getTotalPrice(cart: snapshot.data[CART]);
  }

  int getTotalPrice({List cart}){
    if(cart == null){
      return 0;
    }
    for(Map cartItem in cart){
      _priceSum += cartItem["price"] * cartItem["quantity"];
    }

    int total = _priceSum;

    return total;
  }
}