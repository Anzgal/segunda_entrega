import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  static const NAME = "name";
  static const LAST = "last";
  static const EMAIL = "email";
  static const PHONE = "phone";
  static const ID = "id";
  static const ZIP = "zip";
  static const ADDRESS = "address";

  String _name;
  String _last;
  String _email;
  String _phone;
  String _id;
  int _zip;
  String _address;

  String get name => _name;
  String get last => _last;
  String get email => _email;
  String get phone => _phone;
  String get id => _id;
  int get zip => _zip;
  String get address => _address;


  UserModel.fromSnapshot(DocumentSnapshot snapshot){
    _name = snapshot.data[NAME];
    _last = snapshot.data[LAST];
    _email = snapshot.data[EMAIL];
    _phone = snapshot.data[PHONE];
    _id = snapshot.data[ID];
    _zip = snapshot.data[ZIP];
    _address = snapshot.data[ADDRESS];

  }
}