import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../helpers/order.dart';
import '../services/user.dart';
import '../models/order.dart';
import '../models/products.dart';
import '../models/user.dart';
import 'package:uuid/uuid.dart';


enum Status{Uninitialized, Authenticated, Authenticating, Unauthenticated}

class AuthProvider with ChangeNotifier{
  //auth = providers/user.dart
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  Firestore _firestore = Firestore.instance;
  UserServices _userServicse = UserServices();
  OrderServices _orderServices = OrderServices();
  UserModel _userModel;

//  getter
  UserModel get userModel => _userModel;
  Status get status => _status;
  FirebaseUser get user => _user;

  // public variables
  List<OrderModel> orders = [];

  final formkey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController last = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController address = TextEditingController();


  AuthProvider.initialize(): _auth = FirebaseAuth.instance{
    _auth.onAuthStateChanged.listen(_onStateChanged);
  }

  Future<bool> signIn()async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email.text.trim(), password: password.text.trim());
      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }


  Future<bool> signUp()async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email.text.trim(), password: password.text.trim()).then((result){
        _firestore.collection('users').document(result.user.uid).setData({
          'name':name.text,
          'last':last.text,
          'email':email.text,
          'phone':phone.text,
          'zip':int.parse(zip.text),
          'address':address.text,
          'uid':result.user.uid,
          'likedFood':[],
          'likedRestaurants':[],
        });
      });
      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  void updateUserData(String id){
    _firestore.collection('users').document(id).updateData({
      'name':name.text,
      'last':last.text,
      'email':email.text,
      'phone':phone.text,
      'zip':int.parse(zip.text),
      'address':address.text,
      'uid':id,
      'likedFood':[],
      'likedRestaurants':[],
    });
  }

  Future<bool> updateUser()async{
    try{
      _status = Status.Authenticated;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email.text.trim(), password: password.text.trim()).then((result){
        _firestore.collection('users').document(result.user.uid).setData({
          'name':name.text,
          'last':last.text,
          'email':email.text,
          'phone':phone.text,
          'zip':int.parse(zip.text),
          'address':address.text,
          'uid':result.user.uid,
          'likedFood':[],
          'likedRestaurants':[],
        });
      });
      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut()async{
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  void clearController(){
    name.text = "";
    password.text = "";
    email.text = "";
  }

  Future<void> reloadUserModel()async{
    _userModel = await _userServicse.getUserById(user.uid);
    notifyListeners();
  }


  Future<void> _onStateChanged(FirebaseUser firebaseUser) async{
    if(firebaseUser == null){
      _status = Status.Unauthenticated;
    }else{
      _user = firebaseUser;
      _status = Status.Authenticated;
      _userModel = await _userServicse.getUserById(user.uid);
    }
    notifyListeners();
  }

  Future<bool> addToCard({ProductModel product, int quantity})async{


    try{
      var uuid = Uuid();
      String cartItemId = uuid.v4();
      List cart = _userModel.cart;
//      bool itemExists = false;
      Map cartItem ={
        "id": cartItemId,
        "name": product.name,
        "image": product.image,
        "productId": product.id,
        "price": product.price,
        "quantity": quantity
      };

//      for(Map item in cart){
//        if(item["productId"] == cartItem["productId"]){
////          call increment quantity
//          itemExists = true;
//          break;
//        }
//      }

//      if(!itemExists){
      print("CART ITEMS ARE: ${cart.toString()}");
      _userServicse.addToCart(userId: _user.uid, cartItem: cartItem);
//      }



      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }

  }

  getOrders()async{
    orders = await _orderServices.getUserOrders(userId: _user.uid);
    notifyListeners();
  }

  Future<bool> removeFromCart({Map cartItem})async{
    print("THE PRODUC IS: ${cartItem.toString()}");

    try{
      _userServicse.removeFromCart(userId: _user.uid, cartItem: cartItem);
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }

  }
}