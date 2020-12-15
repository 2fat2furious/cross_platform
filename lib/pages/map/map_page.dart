import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:map_controller/map_controller.dart';
import 'package:geolocator/geolocator.dart';


class MapPage extends StatefulWidget {

  static const routeName = '/map';

  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController mapController;
  StatefulMapController statefulMapController;
  StreamSubscription<StatefulMapControllerStateChange> sub;
  StreamSubscription<Position> positionStream ;
  double currentZoom = 10.0;
  bool isInit = true;
  LatLng currentCenter = LatLng(53.20, 50.15);
  LatLng lastPosition = LatLng(53.20, 50.15);
  int i = 0;

  @override
  void initState(){
    mapController = MapController();
    statefulMapController = StatefulMapController(mapController: mapController);

    // wait for the controller to be ready before using it
    statefulMapController.onReady.then((_) => {
      print('The map controller is ready'),
      _determinePosition()
    });

    sub = statefulMapController.changeFeed.listen((change) => setState(() {}));

    positionStream = Geolocator.getPositionStream(distanceFilter: 5).
      listen((Position position) {
        if(isInit){
          print("isInit");
          lastPosition = LatLng(position.latitude, position.longitude);
          isInit = false;
        }
        else {
          statefulMapController.addLine(
              name: 'name' + i.toString(),
              points: [
                LatLng(position.latitude, position.longitude),
                lastPosition
              ],
              width: 1.5,
              color: Colors.red,
              isDotted: false);
          lastPosition = LatLng(position.latitude, position.longitude);
          i++;
        }
        statefulMapController.addMarker(marker: Marker(
            height: 120.0,
            width: 100.0,
            point: LatLng(position.latitude, position.longitude),
            builder: (BuildContext context) {
              return Icon(Icons.location_on, color: Colors.red, size: 50.0,);
            }), name: 'Marker');
        mapController.move(LatLng(position.latitude, position.longitude), currentZoom);
    });

    super.initState();
  }

  @override
  void dispose(){
    positionStream.cancel();
    sub.cancel();
    super.dispose();
  }

  void zoomMinus() {
    currentZoom--;
    statefulMapController.zoomOut();
  }

  void zoomPlus() {
    currentZoom++;
    statefulMapController.zoomIn();
  }

  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).appName),
      ),
      body: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            onTap: (pos) {
              print(pos);
            },
            zoom: currentZoom,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: 'http://tiles.maps.sputnik.ru/{z}/{x}/{y}.png',
            ),
            MarkerLayerOptions(markers: statefulMapController.markers),
            PolylineLayerOptions(polylines: statefulMapController.lines),
          ]
      ),
      floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: "btn1",
              onPressed: zoomPlus,
              tooltip: 'Zoom1',
              child: Icon(Icons.zoom_in),
            ),
            FloatingActionButton(
              heroTag: "btn2",
              onPressed: zoomMinus,
              tooltip: 'Zoom',
              child: Icon(Icons.zoom_out),
            ),
          ]
      ),
    );
  }
}