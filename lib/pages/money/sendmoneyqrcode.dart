

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/component/alert.dart';
import 'package:fooddelivery/component/myappbar.dart';
import 'package:fooddelivery/component/valid.dart';
import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/main.dart';

class SendMoneyQrCode extends StatefulWidget {
  SendMoneyQrCode({Key key}) : super(key: key);

  @override
  _SendMoneyQrCodeState createState() => _SendMoneyQrCodeState();
}

class _SendMoneyQrCodeState extends State<SendMoneyQrCode> {
  Crud crud = new Crud();
  var units;
  var phone;
  String userid = sharedPrefs.getString("id");
  String username = sharedPrefs.getString("username");
  String balance = sharedPrefs.getString("balance");
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  transferMoneyQrCode() async {
    var formdata = formstate.currentState;
    if (formdata.validate()) {
      formdata.save();
      if (double.parse(balance) < double.parse(units)) {
        showdialogall(context, "تنبيه", "رصيدك الحالي $balance غير كافي ");
      } else {
        var options = ScanOptions();
        var result = await BarcodeScanner.scan(options: options);

        // if (result.type.toString() == "Cancelled") {
        //   print("yes cancel");
        //   return "cancel" ;
        // }
        if (result.type.toString() == "Barcode") {
          phone = result.rawContent;

          showLoading(context);
          Map data = {
            "phone": phone,
            "units": units,
            "userid": userid,
            "username": username
          };
          var responsbody = await crud.writeData("transfermoney", data);
          if (responsbody['status'] == "success") {
            // SharedPreferences prefs =  await SharedPreferences.getInstance();
            List usersaftercheckout = await crud.readDataWhere("users", userid);
            sharedPrefs.setString(
                "balance", usersaftercheckout[0]['user_balance'].toString());
            Navigator.of(context).pushNamed("home");
          } else {
            Navigator.of(context).pop();
            showAlertOneChoose(
                context, "warning", "تنبيه", "هذا المستخدم غير موجو");
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Form(
            autovalidateMode: AutovalidateMode.always,
            key: formstate,
            child: Column(
              children: [
                MyAppBar(
                  currentpage: "transfermoney",
                  titlepage: "تحويل الاموال",
                ),
                // SizedBox(height: 50) ,
                buildTextForm("ادخل الرصيد الذي تريد تحويله",
                    Icon(Icons.monetization_on), "units"),
       
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () {
                    transferMoneyQrCode();
                  },
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    child: Text(
                      "QrCode تحويل ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                )
              ],
            ),
          ) ,
    );
  }

  TextFormField buildTextForm(String label, Icon icons, [type]) {
    return TextFormField(
        onSaved: (val) {
          if (type == "units") {
            units = val;
          }
          if (type == "phone") {
            phone = val;
          }
        },
        validator: (val) {
          if (type == "units") {
            return validInput(val, 0, 6, "يكون تحويل الرصيد ", "number");
          }
          if (type == "phone") {
            return validInput(val, 0, 20, "يكون رقم الهاتف", "phone");
          }
          return null;
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white,
            prefixIcon: icons));
  }
}
