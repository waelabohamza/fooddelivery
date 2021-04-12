import 'package:fooddelivery/const.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'dart:io';

String basicAuth = 'Basic ' +
    base64Encode(utf8.encode(
        'TalabGoUser@58421710942258459:TalabGoPassword@58421710942258459'));
Map<String, String> myheaders = {
  // 'content-type': 'application/json',
  // 'accept': 'application/json',
  'authorization': basicAuth
};

class Crud {
  readData(String type) async {
    var url;
    if (type == "imagehome") {
      url = "https://$serverName/imagehome/imagehome.php";
    }
    if (type == "categories") {
      url = "https://$serverName/categories/categories.php";
    }
    if (type == "catsres") {
      url = "https://$serverName/catsres/catsres.php";
    }
    if (type == "cattaxi") {
      url = "https://$serverName/taxi/cattaxi.php";
    }
    if (type == "taxi") {
      url = "https://$serverName/taxi/taxi.php";
    }
    if (type == "restaurants") {
      url = "https://$serverName/restaurants/restaurants.php";
    }
    if (type == "items") {
      url = "https://$serverName/items/items.php";
    }
    if (type == "countall") {
      url = "https://$serverName/countall.php";
    }
    if (type == "restaurantstopselling") {
      url = "https://$serverName/restaurants/restaurantstopselling.php";
    }
    if (type == "offers") {
      url = "https://$serverName/offers/offers.php";
    }
    try {
      var response = await http.get(url, headers: myheaders);
      if (response.statusCode == 200) {
        print(response.body);
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("page not found");
      }
    } catch (e) {
      print("error caught : ");
      print(e);
    }
  }

  readDataWhere(String type, String value) async {
    var url;
    var data;
    if (type == "restaurants") {
      url = "https://$serverName/restaurants/restaurants.php";
      data = {"resapprove": value};
    }
    if (type == "restaurantstype") {
      url = "https://$serverName/restaurants/restaurants.php";
      data = {"type": value};
    }

    if (type == "items") {
      url = "https://$serverName/items/items.php";
      data = {"resid": value};
    }
    if (type == "users") {
      url = "https://$serverName/users/users.php";
      data = {"userid": value};
    }

    if (type == "orderdetails") {
      url = "https://$serverName/orders/orders_details.php";
      data = {"ordersid": value};
    }
    if (type == "searchcats") {
      url = "https://$serverName/categories/searchcateories.php";
      data = {"search": value};
    }
    if (type == "searchrestaurants") {
      url = "https://$serverName/restaurants/searchrestaurants.php";
      data = {"search": value};
    }
    // start message
    if (type == "messages") {
      url = "https://$serverName/message/messageusers.php";
      data = {"userid": value};
    }

    if (type == "deliveryways") {
      url = "https://$serverName/restaurants/deliveryways.php";
      data = {"resid": value};
    }
    if (type == "searchall") {
      url = "https://$serverName/seachall.php";
      data = {"search": value};
    }
     if (type == "balance") {
      url = "https://$serverName/money/balance.php";
      data = {"userid": value};
    }
    try {
      var response = await http.post(url, body: data, headers: myheaders);
      if (response.statusCode == 200) {
        print(response.body);
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("page not found");
      }
    } catch (e) {
      print("error caught : ");
      print(e);
    }
  }

  writeData(String type, var data) async {
    var url;
    // start items
    if (type == "searchitems") {
      url = "https://$serverName/items/searchitems.php";
    }
    if (type == "items") {
      url = "https://$serverName/items/items.php";
    }
    // Start Sign
    if (type == "login") {
      url = "https://$serverName/auth/login.php";
    }
    if (type == "signup") {
      url = "https://$serverName/auth/signup.php";
    }
    if (type == "logout") {
      url = "https://$serverName/auth/logout.php";
    }
    if (type == "resetpassword") {
      url = "https://$serverName/resetpassword.php";
    }
    if (type == "verfiycode") {
      url = "https://$serverName/verfiycode.php";
    }
    if (type == "newpassword") {
      url = "https://$serverName/newpassword.php";
    }
    // Start Money
    if (type == "transfermoney") {
      url = "https://$serverName/money/transfermoneyusers.php";
    }
    // start taxi
    if (type == "nearbytaxi") {
      url = "https://$serverName/taxi/nearbytaxi.php";
    }
    if (type == "orderstaxi") {
      url = "https://$serverName/taxi/orderstaxi.php";
    }
    // Start orders
    if (type == "orders") {
      url = "https://$serverName/orders/ordersusers.php";
    }
    if (type == "addorderstaxi") {
      url = "https://$serverName/taxi/addordertaxi.php";
    }
    if (type == "getlocation") {
      url = "https://$serverName/taxi/getupdatelocation.php";
    }

    // Edit Settings

    if (type == "settingsuser") {
      url = "https://$serverName/settings/settingsusers.php";
    }
    if (type == "bill") {
      url = "https://$serverName/money/bill.php";
    }
    if (type == "alerm") {
      url = "https://$serverName/message/alarmres.php";
    }

    try {
      var response = await http.post(Uri.parse(url), body: data, headers: myheaders);

        print("===================================================");
        print(response.body);

      if (response.statusCode == 200) {
        print(response.body);
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("page Not found Write Data  ${response.statusCode}");
      }
    } catch (e) {
      print("error caught : ");
      print(e);
    }
  }

  addOrders(String type, var data) async {
    var url = "https://$serverName/orders/checkout.php";
    var response =
        await http.post(url, body: json.encode(data), headers: myheaders);
    if (response.statusCode == 200) {
      print(response.body);
      var responsebody = response.body;
      return responsebody;
    } else {
      print("page Not found");
    }
  }

  Future addUsers(email, password, username, phone, File imagefile) async {
    var stream = new http.ByteStream(imagefile.openRead());
    stream.cast();
    var length = await imagefile.length();
    var uri = Uri.parse("https://$serverName/auth/signup.php");
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(myheaders);
    var multipartFile = new http.MultipartFile("file", stream, length,
        filename: basename(imagefile.path));
    request.fields["email"] = email;
    request.fields["password"] = password;
    request.fields["username"] = username;
    request.fields["phone"] = phone;
    request.files.add(multipartFile);
    var myrequest = await request.send();
    var response = await http.Response.fromStream(myrequest);
    if (myrequest.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }
  }

  Future editUsers(username, email, password, phone, id, bool issfile,
      [File imagefile]) async {
    var uri = Uri.parse("https://$serverName/users/editusers.php");

    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(myheaders);
    if (issfile == true) {
      var stream = new http.ByteStream(imagefile.openRead());
      stream.cast();
      var length = await imagefile.length();
      var multipartFile = new http.MultipartFile("file", stream, length,
          filename: basename(imagefile.path));
      request.files.add(multipartFile);
    }
    request.fields["username"] = username;
    request.fields["email"] = email;
    request.fields["password"] = password;
    request.fields["userid"] = id;
    request.fields["phone"] = phone;

    var myrequest = await request.send();
    var response = await http.Response.fromStream(myrequest);
    if (myrequest.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }
  }
}
