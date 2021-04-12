import 'package:flutter/material.dart';
import 'package:fooddelivery/component/alert.dart';
import 'package:fooddelivery/component/myappbar.dart';
import 'package:fooddelivery/component/valid.dart';
import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/main.dart';

class TransferMoney extends StatefulWidget {
  TransferMoney({Key key}) : super(key: key);

  @override
  _TransferMoneyState createState() => _TransferMoneyState();
}

class _TransferMoneyState extends State<TransferMoney> {
  Crud crud = new Crud();
  var units;
  var phone;
  String userid = sharedPrefs.getString("id");
  String username = sharedPrefs.getString("username");
  String balance = sharedPrefs.getString("balance");
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  transferMoney() async {
    var formdata = formstate.currentState;
    if (formdata.validate()) {
      formdata.save();
      if (double.parse(balance) < double.parse(units)) {
        showdialogall(context, "تنبيه", "رصيدك الحالي $balance غير كافي ");
      } else {
        showLoading(context);
        Map data = {
          "phone": phone.toString(),
          "units": units.toString(),
          "userid": userid.toString(),
          "username": username.toString()
        };
        var responsbody = await crud.writeData("transfermoney", data);
        if (responsbody['status'] == "success") {
          Navigator.of(context).pushNamed("home");
        } else {
          Navigator.of(context).pop() ; 
          showAlertOneChoose(context, "warning", "تنبيه", "هذا المستخدم غير موجو")   ; 
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
  
      body: Form(
            autovalidateMode: AutovalidateMode.always,
            key: formstate,
            child: Column(
              children: [
                MyAppBar(currentpage: "transfermoney",titlepage: "تحويل الاموال",) , 
                // SizedBox(height: 50) , 
                buildTextForm("ادخل الرصيد الذي تريد تحويله",
                    Icon(Icons.monetization_on), "units"),
                buildTextForm("ادخل رقم الذي تريد التحويل له",
                    Icon(Icons.phone), "phone"),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () {
                    transferMoney();
                  },
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    child: Text(
                      " تحويل ",
                      style: TextStyle(color: Colors.black, fontSize: 20 , fontWeight: FontWeight.w300),
                    ),
                  ),
                )
              ],
            ),
          ),
           
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
          return null  ; 
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white,
            prefixIcon: icons));
  }
}
