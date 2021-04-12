import 'package:flutter/material.dart';
import 'package:fooddelivery/component/myappbar.dart';
import 'package:fooddelivery/main.dart';
import 'package:qr_flutter/qr_flutter.dart';

String phone = sharedPrefs.getString("phone");
class ReciveMoney extends StatelessWidget {
  final mdw;
  const ReciveMoney({Key key, this.mdw}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            MyAppBar(currentpage: "recivemoney", titlepage: "استقبال الاموال"),
            SizedBox(height: 100),
            QrImage(
              data: "phone",
              version: QrVersions.auto,
              size: mdw,
            ),
            Text("$phone")
          ],
        ),
      ),
    );
  }
}
