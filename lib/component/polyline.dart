import 'package:flutter/material.dart';  
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http ;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

  // for polyline 
  Set<Polyline> polylineSet = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Future<void> getDirectionLocation(lat , long , destlat , destlong) async {
    var details ; 
     // Start Api Directions 
     var url = "https://maps.googleapis.com/maps/api/directions/json?origin=${lat},${long}&destination=${destlat},${destlong}&key=AIzaSyDfv8bynd-akV_9fDKloFFLcQ1lMvQADGg" ; 
     var response = await http.post(url) ; 
     var responsebody = jsonDecode(response.body) ;
     polylineCoordinates.clear() ; 
     var encodedetails = responsebody['routes'][0]['overview_polyline']['points'] ; 
     // Start Draw Poly Line 
    List<PointLatLng> decodepolylinepointresult =   polylinePoints.decodePolyline(encodedetails) ; 
    if (decodepolylinepointresult.isNotEmpty) {
      decodepolylinepointresult.forEach((PointLatLng pointLatLng) {
        polylineCoordinates.add(LatLng(pointLatLng.latitude,pointLatLng.longitude)) ; 
      }) ;    
    }
    polylineSet.clear() ; 
      // setState(() {
        Polyline polyline = Polyline(
          polylineId: PolylineId("pp"),  
          color: Colors.red , 
          jointType: JointType.round , 
          points: polylineCoordinates , 
          width: 5 , 
          startCap: Cap.roundCap , 
          endCap: Cap.roundCap , 
          geodesic: true 
        ) ; 
        polylineSet.add(polyline) ; 
      // });
    // End Draw Poly Line 
     return encodedetails ; 
   }
