import 'dart:async';
import 'dart:math';
import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/component/polyline.dart';
import 'package:fooddelivery/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Delivery extends StatefulWidget {

  final lat;
  final long;
  final destlat;
  final destlong;
  final orderid;
  final statusorders;
  final taxiid;
  Delivery(
      {Key key,
      this.lat,
      this.long,
      this.orderid,
      this.statusorders,
      this.destlat,
      this.destlong,
      this.taxiid})
      : super(key: key);

  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  Crud crud = new Crud();

  List<Marker> markers = [];
  GoogleMapController _controller;
  Position position;
  StreamSubscription<Position> positionStream;

  Timer _timer;
  var currentlat;
  var currentlong;

  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor pinCustomerIcon;
  BitmapDescriptor pinTargetIcon;

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'images/car.png');
  }

  void setCustomerPin() async {
    markers.add(Marker(
        markerId: MarkerId(Random().nextInt(1000).toString()),
        infoWindow: InfoWindow(title: "موقع الزبون"),
        position: LatLng(double.parse(widget.lat.toString()),
            double.parse(widget.long.toString())),
        draggable: true,
        onDragEnd: (ondragend) {
          print(ondragend);
        }));
  }

  void setTargetPin() async {
    markers.add(Marker(
        markerId: MarkerId(Random().nextInt(1000).toString()),
        infoWindow: InfoWindow(title: "الهدف"),
        position: LatLng(double.parse(widget.destlat.toString()),
            double.parse(widget.destlong.toString())),
        draggable: true,
        icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'images/target.png'),
        onDragEnd: (ondragend) {
          print(ondragend);
        }));
  }

  getTaxiLocation() async {
    // position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    markers.removeWhere((element) => element.markerId.value == "2");
    var data = {"taxiid": widget.taxiid};
    var responsebody = await crud.writeData("getlocation", data);
    var taxilat = double.parse(responsebody[0]['taxi_lat'].toString());
    var taxilong = double.parse(responsebody[0]['taxi_long'].toString());
    print("=================== aaaaaaaaaa");
    print(taxilat);
    print(taxilong);
    print("===================");

    markers.add(
      Marker(
          markerId: MarkerId("2"),
          infoWindow: InfoWindow(title: "موقعي السائق"),
          position: LatLng(taxilat, taxilong),
          draggable: true,
          icon: pinLocationIcon,
          onDragEnd: (ondragend) {
            print(ondragend);
          }),
    );

    if (this.mounted) {
      setState(() {});
    }
    _timer = Timer(Duration(seconds: 30), () {
      getTaxiLocation();
    });
  }

  triggerdPolyLine() async {
    await getDirectionLocation(
        widget.lat, widget.long, widget.destlat, widget.destlong);
    setState(() {});
  }

  @override
  void initState() {
    setCustomMapPin();
    setCustomerPin();
    setTargetPin();
    getTaxiLocation();
    super.initState();
    triggerdPolyLine();
    print(markers);

    positionStream = Geolocator.getPositionStream().listen((Position position) {
      print("rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr") ;
         updatePinMap(position) ;
               if (this.mounted){
                 setState(() {

                 });
               }
    });
  }

  updatePinMap(cl) {
    markers.removeWhere((element) => element.markerId.value == "1");
    markers.add(
      Marker(
          markerId: MarkerId("1"),
          infoWindow: InfoWindow(title: "موقعي الحالي"),
          position: LatLng(cl.latitude, cl.longitude),
          draggable: true,
          onDragEnd: (ondragend) {
            print(ondragend);
          }),
    );
  }

  @override
  void dispose() {
    if (positionStream != null) {
      positionStream.cancel();
      positionStream = null;
    }
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double mdh = MediaQuery.of(context).size.height;
    return  Scaffold(
          appBar: AppBar(
            title: Text('حالة الطلبية'),
          ),
          body: WillPopScope(
              child: Stack(
                children: [
                  Container(
                      height: mdh,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(double.parse(widget.lat.toString()),
                                double.parse(widget.long.toString())),
                            zoom: 10),
                        markers: markers.toSet(),
                        onTap: (latlng) {},
                        onMapCreated: onMapCreated,
                        polylines:
                            polylineSet, //Set<Polyline>.of(polylines.values) ,
                        myLocationEnabled: true,
                        tiltGesturesEnabled: true,
                        compassEnabled: true,
                        scrollGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                      ))
                ],
              ),
              onWillPop: () {
                Navigator.of(context).pushReplacementNamed("home");
                return null;
              }),
        );
  }

  onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }
}
