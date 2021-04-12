import 'package:flutter/material.dart';
import 'package:fooddelivery/component/addtocart.dart';
import 'package:fooddelivery/component/alert.dart';
import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/component/myappbar.dart';
import 'package:fooddelivery/component/qrcode.dart';
import 'package:fooddelivery/main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class CheckOut extends StatefulWidget {
  final resid;
  CheckOut({Key key, this.resid}) : super(key: key);

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  var lat, long;

  Crud crud = new Crud();

  bool loading = true;

  String type = "delivery";

  var typeDelivery;

  var resid;

  int ordertable = 0;
  Pattern pattern = r'(^(?:[+0]9)?[0-9])';

  String userid = sharedPrefs.getString("id");
  String username = sharedPrefs.getString('username');
  String balance = sharedPrefs.getString("balance");

  getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (this.mounted) {
      setState(() {
        lat = position.latitude;
        long = position.longitude;
      });
    }
  }

  checkpermission(context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      await getCurrentLocation();
    } else {
      permission = await Geolocator.requestPermission();
      showdialogall(context, "تنبيه",
          "لا يمكن استخدام التطبيق من دون اعطاء صلاحية الوصول للموقع");
      await Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pushNamed("home");
      });
    }
  }

  @override
  void initState() {
    resid = widget.resid;
    checkpermission(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var addtocart = Provider.of<AddToCart>(context);

    checkOut(typeDelivery) async {
      if (typeDelivery == "tableqrcode") {
        var result = await scanQrCode();
        RegExp regex = new RegExp(pattern);
        if (result != "cancel" &&
            result != "faild" &&
            !regex.hasMatch(result)) {
          // ordertable = result;
          showdialogall(context, "خطا", "الرجاء المحاولة مرة اخرى");
          return;
        }
        ordertable = int.parse(result);
      }
      var data = {
        "resid": addtocart.listres.isNotEmpty ? addtocart.listres[0] : "0",
        "listfood": addtocart.basketnoreapt,
        "quantity": addtocart.quantity,
        'userid': userid,
        'totalprice':
            addtocart.sumtotalprice, // total price with price delivery
        'lat': lat,
        'long': long,
        'timenow': DateTime.now().toString(),
        "type": typeDelivery.toString(),
        "ordertable": ordertable.toString()
      };
      if (double.parse(addtocart.sumtotalprice.toString()) <=
              double.parse(balance.toString()) &&
          addtocart.basketnoreapt.isNotEmpty) {
        if (lat == null || long == null) {
          showdialogall(
              context, "تنبيه", "تاكد من تحديد بيانات الموقع الخاص بك");
        } else {
          showLoading(context);
          await crud.addOrders("checkout", data);
          // SharedPreferences prefs =
          //     await SharedPreferences.getInstance();
          List usersaftercheckout =
              await crud.readDataWhere("users", sharedPrefs.getString("id"));
          sharedPrefs.setString(
              "balance", usersaftercheckout[0]['user_balance'].toString());
          Provider.of<AddToCart>(context, listen: false).removeAll();
          Navigator.of(context).pushReplacementNamed("myorders");
        }
      } else if (addtocart.basketnoreapt.isEmpty) {
        showdialogall(context, "تنبيه", " لا يوجد اي منتج للشراء ");
      } else {
        showdialogall(context, "تنبيه", "الرصيد غير كافي");
        print(addtocart.basketnoreapt.toString());
      }
    }

    return Scaffold(
      body: Container(
        child: ListView(children: [
          MyAppBar(currentpage: "checkout", titlepage: "الدفع"),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text(
              "اختر الطريقة المناسبة",
              style: TextStyle(fontSize: 20, color: Colors.brown),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildImageTalab("images/chekout/6.jpg", "توصيل", () {
                setState(() {
                  type = "delivery";
                });
              }),
              buildImageTalab("images/chekout/4.jpg", "استلام", () {
                setState(() {
                  type = "receipt";
                });
              }),
            ],
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text(
              "${type == 'delivery' ? 'اختر طريقة التوصيل' : 'اختر طريقة الاستلام'}",
              style: TextStyle(fontSize: 20, color: Colors.brown),
            ),
          ),
          TypeDelivery(
            visible: type == "delivery" ? true : false,
            url: "images/chekout/6.jpg",
            body: "ايصال الطلب الى المكان الموجود فيه حاليا ",
            title: " توصيل الطلبية",
            function: () async {
              await checkOut("delivery");
            },
          ),
          FutureBuilder(
            future: crud.readDataWhere("deliveryways", resid.toString()),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return TypeDelivery(
                        visible: type != "delivery" ? true : false,
                        url: "${snapshot.data[i]['deliveryways_image']}",
                        body: "${snapshot.data[i]['deliveryways_ar']}",
                        title: "استلام الطلبية",
                        function: () async {
                          await checkOut(
                              "${snapshot.data[i]['deliveryways_name']}");
                        },
                      );
                    });
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ]),
      ),
    );
  }

  InkWell buildImageTalab(url, title, navigate()) {
    return InkWell(
        onTap: navigate,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      url,
                      height: 110,
                      width: 150,
                      fit: BoxFit.fill,
                    )),
                Container(child: Text("$title"))
              ],
            )));
  }
}

class TypeDelivery extends StatelessWidget {
  final title;
  final body;
  final url;
  final visible;
  final Function function;
  TypeDelivery({this.body, this.function, this.title, this.url, this.visible});
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: InkWell(
        onTap: () {
          function();
        },
        child: Container(
          child: Card(
              child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                  child: Image.asset(
                    "$url",
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                    height: 110,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            "$title",
                            style: TextStyle(color: Colors.brown),
                          ),
                          subtitle: Text("$body"),
                        )
                      ],
                    ),
                  ))
            ],
          )),
        ),
      ),
    );
  }
}
