import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/animation/ScaleRoute.dart';
import 'package:flutter_app/providers/app.dart';
import 'package:flutter_app/providers/product.dart';
import 'package:flutter_app/providers/restaurant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'ShopScreen.dart';

class MapPage extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapPage> {
  Completer<GoogleMapController> controller1;

  //static LatLng _center = LatLng(-15.4630239974464, 28.363397732282127);
  static LatLng _initialPosition;
  final Set<Marker> _markers = {};
  static  LatLng _lastMapPosition = _initialPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocation();



  }
  @override
  void didChangeDependencies() {
    //add markers
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final app = Provider.of<AppProvider>(context);

    for(var restaurant in restaurantProvider.restaurants){
      var latlongarr =  restaurant.location.split(",");
      double latitude = double.parse(latlongarr[0]);
      double longitude = double.parse(latlongarr[1]);
      LatLng restaurantLocation = new LatLng(latitude, longitude);
      _markers.add(
          Marker(
              markerId: MarkerId(restaurant.location),
              position: restaurantLocation,
              infoWindow: InfoWindow(
                  title: restaurant.name,
                  snippet: "Rating: " + restaurant.rating.toString(),
                onTap: () async {
                  app.changeLoading();

                  await productProvider.loadProductsByRestaurant(
                      restaurantId: restaurant.id);
                  app.changeLoading();


                  Navigator.push(context, ScaleRoute(page: RestaurantScreen(
                    restaurantModel: restaurant,
                  )));
                },
              ),
              onTap: (){
              },

              icon: BitmapDescriptor.defaultMarker));
    }
    super.didChangeDependencies();
  }
  void _getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      print('${placemark[0].name}');
    });
  }


  _onMapCreated(GoogleMapController controller) {
    setState(() {
      controller1.complete(controller);
    });
  }

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }


  Widget mapButton(Function function, Icon icon, Color color) {
    return RawMaterialButton(
      onPressed: function,
      child: icon,
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: color,
      padding: const EdgeInsets.all(7.0),
    );
  }
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: _initialPosition == null ? Container(child: Center(child:Text('cargando mapa..', style: TextStyle(fontFamily: 'Avenir-Medium', color: Colors.grey[400]),),),) : Container(
        child: Stack(children: <Widget>[
          GoogleMap(
            markers: _markers,

            mapType: _currentMapType,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 14.4746,
            ),
            onMapCreated: _onMapCreated,
            zoomGesturesEnabled: true,
            onCameraMove: _onCameraMove,
            myLocationEnabled: true,
            compassEnabled: true,


          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
                margin: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                child: Column(

                  children: <Widget>[
                    SizedBox(height: 20,),
                    mapButton(
                        _onMapTypeButtonPressed,
                        Icon(
                          IconData(0xf473,
                              fontFamily: CupertinoIcons.iconFont,
                              fontPackage: CupertinoIcons.iconFontPackage),
                        ),
                        Colors.red),
                  ],
                )),
          )
        ]),
      ),
    );
  }
}