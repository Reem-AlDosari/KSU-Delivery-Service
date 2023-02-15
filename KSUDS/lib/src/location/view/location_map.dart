import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kcds/src/auth/model/user_data.dart';
import 'package:kcds/src/base/customer/order/model/order.dart';
import 'package:kcds/src/location/model/location_model.dart';
import 'package:kcds/src/location/view_model/location_viewmodal.dart';
import 'package:provider/provider.dart';
import 'package:kcds/src/auth/view_model/auth_vm.dart';
import 'package:location/location.dart';
String googleAPiKey = "AIzaSyDSWRJiMePnSP3XAITuPxMoVjq7nyZojXw";

class MapPage extends StatefulWidget {
  final bool isCustomer;
  final Order? order;

  const MapPage({this.isCustomer=false,this.order,Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  PolylinePoints polylinePoints = PolylinePoints();

  bool isCustomer = true;

  Set<Marker> _markers = Set();
  Set<Polyline> _polyline = {};
  Set<Polyline> _polylineEmpty = {};

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.723353960500027, 46.63682819868038),
    zoom: 17.4746,
  );

  static CameraPosition _kStore = CameraPosition(
      target: LatLng(24.723353960500027, 46.63682819868038), zoom: 18);

  late RoomProvider _roomProvider;

  List<LatLng> polylineCoordinates = [];
  List<EachLine> resultLine = [];

  int selectRes = 0;
  late Detail rest;
  int index = 0;
  int selectedLine = -1;

  Future<void> computePath(LatLng end, String id) async {
    polylineCoordinates = [];
    _kStore = CameraPosition(
        target: LatLng(
            rest.lat ?? 24.723353960500027, rest.long ?? 46.63682819868038),
        zoom: 18);
    resultLine = await GetRouteByMap().getRoutesList(
        _kStore.target, LatLng(end.latitude, end.longitude), 'walking');
    int index = 0;
    for (var eachLine in resultLine) {
      eachLine.points?.forEach((LatLng element) {
        polylineCoordinates.add(element);
      });
      final _random = Random();
      _polyline.add(Polyline(
          polylineId: PolylineId('iter' + index.toString()),
          visible: true,
          points: polylineCoordinates,
          width: 3,
          color: Colors.lightBlue,
          // color: Color.fromARGB(_random.nextInt(256), _random.nextInt(256),
          //     _random.nextInt(256), _random.nextInt(256)),
          startCap: Cap.roundCap,
          endCap: Cap.buttCap,
          patterns: [PatternItem.dash(15), PatternItem.gap(5)],
          onTap: () {
            selectedLine = index;
            setState(() {});
          }));
      break;
    }
  }

  getPolyline() async {
    print(["_roomProvider.selectedRoom:", _roomProvider.selectedRoom]);
    for (var element in _roomProvider.selectedRoom) {
      await computePath(LatLng(element.dropLat, element.long), element.userId);
    }
    _setMapFitToTour(_polyline);
  }

  void _setMapFitToTour(Set<Polyline> p) async {
    double minLat = p.first.points.first.latitude;
    double minLong = p.first.points.first.longitude;
    double maxLat = p.first.points.first.latitude;
    double maxLong = p.first.points.first.longitude;
    p.forEach((poly) {
      poly.points.forEach((point) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLong) minLong = point.longitude;
        if (point.longitude > maxLong) maxLong = point.longitude;
      });
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(minLat, minLong),
            northeast: LatLng(maxLat, maxLong)),
        20));
  }

  Future<void> insertCarrier()async{
    UserData? userData;
    if(widget.order!=null) {
      if (widget.order?.carrierId != null && widget.order?.carrierId != "") {
        userData = await AuthVM().getUserFromDB(widget.order?.carrierId ?? "");
        if (userData != null) {
          _markers.add(Marker(
              markerId: MarkerId("carrier"),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
              position: LatLng(userData.lat ?? 12.5, userData.long ?? 42.5),
              infoWindow:
                  InfoWindow(title: "carrier: " + (userData.fullName ?? ""))));
          setState(() {
          });
        }
      }
      Future.delayed(Duration(seconds: 3),insertCarrier);
    }
  }

  Future<void> insertMyLocationRestaurant()async{
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    _markers.add(Marker(
        markerId: MarkerId("rest"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: LatLng(
            _locationData.latitude??12.6, _locationData.longitude??42.6),
        infoWindow: InfoWindow(title: "My Position")));
    rest = Detail.fromJson(fixPosition[selectRes]);
    _markers.add(Marker(
        markerId: MarkerId("myLocation"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        position: LatLng(
            rest.lat ?? 24.717441525288805, rest.long ?? 46.61921735518651),
        infoWindow: InfoWindow(title: rest.label)));
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _roomProvider = Provider.of<RoomProvider>(context, listen: false);
    selectRes = _roomProvider.selectedStore;
    for (var element in _roomProvider.selectedRoom) {
      _markers.add(Marker(
          markerId: MarkerId("room" + element.userId),
          position: LatLng(element.dropLat, element.long),
          infoWindow: InfoWindow(title: element.label)));
    }
    getPolyline();
    if(widget.isCustomer){
      insertCarrier();
    }
    insertMyLocationRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            padding: const EdgeInsets.only(bottom: 100),
            markers: _markers,
            polylines: isCustomer ? _polylineEmpty : _polyline,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isCustomer = !isCustomer;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.tealAccent,
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.only(top: 30, left: 10),
              child: Text(isCustomer ? "Show As courier" : "Show as Customer"),
            ),
          ),
          isCustomer
              ? Text("")
              : selectedLine == -1
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(top: 30, right: 10),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.topRight,
                      child: Container(
                        alignment: Alignment.topRight,
                        decoration: BoxDecoration(
                            color: Colors.tealAccent,
                            borderRadius: BorderRadius.circular(15)),
                        height: 40,
                        width: 150,
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              resultLine[selectedLine]
                                      .distanceTime
                                      ?.duration
                                      ?.text
                                      .toString() ??
                                  "no confirmed",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            Icon(Icons.directions_walk_outlined)
                          ],
                        ),
                      ),
                    ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goStore,
        label: const Text('To the Store!'),
        icon: const Icon(Icons.store),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Future<void> _goStore() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kStore));
  }
}
