import 'package:cloud_firestore/cloud_firestore.dart';

class TiendaModel {
  static const ID = "id";
  static const NAME = "name";
  static const AVG_PRICE = "avgPrice";
  static const RATING = "rating";
  static const RATES = "rates";
  static const IMAGE = "image";
  static const POPULAR = "popular";
  static const USER_LIKES = "userLikes";
  static const LOCATION   = "location";




  int _id;
  String _name;
  String _image;
  List<String> _userLikes;
  double _rating;
  double _avgPrice;
  bool _popular;
  int _rates;
  String _location;

//  getters
  int get id => _id;

  String get name => _name;

  String get image => _image;

  List<String> get userLikes => _userLikes;

  double get avgPrice => _avgPrice;

  double get rating => _rating;

  bool get popular => _popular;

  int get rates => _rates;

  String get location => _location;

  // public variable
  bool liked = false;


  TiendaModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data[ID];
    _name = snapshot.data[NAME];
    _image = snapshot.data[IMAGE];
    _avgPrice = snapshot.data[AVG_PRICE];
    _rating = snapshot.data[RATING];
    _popular = snapshot.data[POPULAR];
    _rates = snapshot.data[RATES];
    _location = snapshot.data[LOCATION];
  }
}