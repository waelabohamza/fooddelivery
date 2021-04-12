import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fooddelivery/component/alert.dart';
import 'package:fooddelivery/const.dart';
import 'package:fooddelivery/main.dart';
import 'package:search_map_place/search_map_place.dart';
import "package:flutter/material.dart";
import 'package:fooddelivery/component/crud.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class HomeTaxi extends StatefulWidget {
  HomeTaxi({Key key}) : super(key: key);

  @override
  _HomeTaxiState createState() => _HomeTaxiState();
}

class _HomeTaxiState extends State<HomeTaxi> {
  double lat;
  double long;
  double latdest;
  double longdest;
  String userid = sharedPrefs.getString("id");
  String mytoken = sharedPrefs.getString("token");
  Map data;
  double distancekm;
  String durationtext;

  var distancemeter;

  GoogleMapController _controller;

  Crud crud = new Crud();

  List<Marker> markers = [];

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (this.mounted) {
      setState(() {
        lat = position.latitude;
        long = position.longitude;
        markers.add(Marker(
            markerId: MarkerId(lat.toString()),
            infoWindow: InfoWindow(title: "موقعي الحالي"),
            position: LatLng(lat, long)));
      });
    }
  }

  double mydistanceBetween(lat, long, destlat, destlong) {
    double distanceInMeters =
        Geolocator.distanceBetween(lat, long, destlat, destlong);
    return distanceInMeters;
  }

  @override
  void initState() {
    // print("userid ===================");
    // print(userid);
    // print(mytoken);
    // print("userid ===================");
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mdh = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('اختر المكان الذي تريد الذهاب اليه '),
      ),
      body: Stack(
        children: [
          lat == null
              ? SizedBox(
                  height: 10,
                )
              : Container(
                  height: mdh,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition:
                        CameraPosition(target: LatLng(lat, long), zoom: 10),
                    markers: markers.toSet(),
                    onTap: _handleTap,
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                    },
                  )),
          Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: SearchMapPlaceWidget(
                  apiKey: "AIzaSyDfv8bynd-akV_9fDKloFFLcQ1lMvQADGg",
                  language: 'ar',
                  placeholder: "ادخل المكان الذي تريد البحث عنه",
                  onSelected: (place) async {
                    Geolocation geolocation = await place.geolocation;
                    _controller.animateCamera(
                        CameraUpdate.newLatLng(geolocation.coordinates));
                    _controller.animateCamera(
                        CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                  })),
          Positioned(
              bottom: 10,
              right: 100,
              left: 100,
              child: RaisedButton(
                color: Colors.brown,
                textColor: Colors.white,
                onPressed: () async {
                  if (latdest != null && longdest != null) {
                    showLoading(context);
                    var allowdriving = await destanceBetweenDriving(
                        lat, long, latdest, longdest);
                    if (allowdriving != "OK") {
                      String title = "تنبيه";
                      String body = "لا يمكن الوصول بالسيارة الى هذا المكان";
                      Navigator.of(context).pop();
                      showdialogall(context, title, body);
                    } else {
                      Navigator.of(context).pop();
                      data = {"lat": lat.toString(), "long": long.toString()};
                      showbottommenu(data);
                    }
                    // showbottommenu();

                  } else {
                    String title = "تنبيه";
                    String body = "يرجى اختيار المكان الذي تريد الذهاب اليه";
                    showAlertOneChoose(context, "warning", title, body);
                  }
                },
                child: Text(
                  "اطلب الان",
                  style: TextStyle(
                      color: Colors.white, fontSize: fontSizeTopRadius),
                ),
              ))
        ],
      ),
    );
  }

  _handleTap(LatLng tappedpoint) {
    setState(() {
      markers.removeWhere((element) => element.markerId.value == "dest");
      markers.add(
        Marker(
            markerId: MarkerId("dest"),
            infoWindow: InfoWindow(title: tappedpoint.toString()),
            position: tappedpoint,
            draggable: true,
            onDragEnd: (ondragend) {
              print(ondragend);
            }),
      );
      latdest = tappedpoint.latitude;
      longdest = tappedpoint.longitude;
      distancemeter = mydistanceBetween(lat, long, latdest, longdest);
      //  distancemeter =    destanceBetweenDriving(lat, long, latdest, longdest);
      // print("=========================== distance ");
      // print(distancemeter / 1000);
      // print("===========================");
    });
  }

  showbottommenu(data) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                // padding: EdgeInsets.all(10),
                height: 420,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        color: Theme.of(context).primaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(
                          " اختر نوع السيارة التى تريد ان تقوم بتوصيلك",
                          style: TextStyle(color: Colors.white),
                        )),
                    Container(
                        height: 330,
                        child: FutureBuilder(
                          future: crud.writeData("nearbytaxi", data),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, i) {
                                    if (snapshot.data[0] == "faild") {
                                      return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  330),
                                          child: Center(
                                              child: Text(
                                            "لا يوجد سيارات قريبة منك",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 20),
                                          )));
                                    }

                                    return BuildCatTaxi(
                                      taxi: snapshot.data[i],
                                      crud: crud,
                                      distancekm: distancekm,
                                      userid: userid,
                                      lat: lat,
                                      long: long,
                                      destlat: latdest,
                                      destlong: longdest,
                                    );
                                  });
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        ))
                  ],
                ),
              ));
        });
  }

  destanceBetweenDriving(lat, long, destlat, destlong) async {
    var url =
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&mode=driving&origins=${lat},${long}&destinations=${destlat}%2C${destlong}&key=AIzaSyDfv8bynd-akV_9fDKloFFLcQ1lMvQADGg";
    var response = await http.post(url);
    var responsebody = jsonDecode(response.body);
    var element = responsebody['rows'][0]['elements'];
    var status = element[0]['status'];

    print(responsebody);
    print("======================================");
    if (status == "OK") {
      var distance = element[0]['distance'];
      var duration = element[0]['duration'];
      var distancetext = distance['text'];
      var distancevalue = distance['value'];
      var durationtext = duration['text'];
      var durationvalue = duration['value'];

      setState(() {
        distancekm = double.parse(distancevalue.toString()) / 1000;
      });
    }
    if (status == "ZERO_RESULTS") {}
    return status;
  }
}

class BuildCatTaxi extends StatelessWidget {
  final taxi;
  final crud;
  final distancekm;
  final userid;
  final lat;
  final long;
  final destlat;
  final destlong;
  const BuildCatTaxi(
      {Key key,
      this.taxi,
      this.crud,
      this.distancekm,
      this.userid,
      this.destlat,
      this.destlong,
      this.lat,
      this.long})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var price = double.parse(taxi['taxi_price'].toString()) *
        double.parse(distancekm.toString());
    var totalprice = price + double.parse(taxi['taxi_mincharge'].toString());
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 300,
        child: Column(
          children: [
            CachedNetworkImage(
                imageUrl:
                    "https://$serverName/upload/taxiimage/${taxi['taxi_image']}",
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
                width: 200,
                height: 150),
            Container(
              child: Text(
                "${taxi['taxi_username']}",
                style: TextStyle(color: Colors.brown),
              ),
            ),
            Container(
              child: Text(
                " هاتف :  ${taxi['taxi_phone']}",
                style: TextStyle(color: Colors.brown),
              ),
            ),
            Container(
              child: Text(
                " سعر  الطلب :  ${totalprice.toStringAsFixed(3)} د.ك",
                style: TextStyle(color: Colors.brown),
              ),
            ),
            RaisedButton(
              onPressed: () async {
                if (double.parse(sharedPrefs.getString("balance")) >
                    double.parse(totalprice.toString())) {
                  Map data = {
                    "userid": userid.toString(),
                    "taxiid": taxi['taxi_id'].toString(),
                    "lat": lat.toString(),
                    "long": long.toString(),
                    "destlat": destlat.toString(),
                    "destlong": destlong.toString(),
                    "price": totalprice.toString(),
                    "distance": distancekm.toString()
                  };
                  showLoading(context);
                  var responsebody =
                      await crud.writeData("addorderstaxi", data);
                  if (responsebody['status'] == "success") {
                    List usersaftercheckout =
                        await crud.readDataWhere("users", userid.toString());
                    sharedPrefs.setString("balance",
                        usersaftercheckout[0]['user_balance'].toString());
                    Navigator.of(context).pushReplacementNamed("home");
                  } else {
                    Navigator.of(context).pop();
                    String mytitle = "تنبيه";
                    String mycontent = "يوجد خطا لم يتم اضافة الطلب";
                    showdialogall(context, mytitle, mycontent);
                  }
                } else {
                  String mytitle = "تنبيه";
                  String mycontent = "رصيدك غير كافي الرجاء التاكد من الرصيد";
                  showdialogall(context, mytitle, mycontent);
                }
              },
              child: Text("طلب"),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
            )
          ],
        ));
  }
}
