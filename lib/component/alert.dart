import 'package:flutter/material.dart';
import 'package:fooddelivery/component/applocal.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

AwesomeDialog showAlert(
    context, type, String mytitle, String mybody, cancel(), ok()) {
  return AwesomeDialog(
    context: context,
    dialogType: type == "success"
        ? DialogType.SUCCES
        : type == "info"
            ? DialogType.INFO
            : type == "error"
                ? DialogType.ERROR
                : type == "warning"
                    ? DialogType.WARNING
                    : DialogType.NO_HEADER,
    animType: AnimType.BOTTOMSLIDE,
    title: mytitle,
    desc: mybody,
    btnCancelOnPress: cancel,
    btnOkOnPress: ok,
  )..show();
}

AwesomeDialog showAlertOneChoose(context, type, String mytitle, String mybody) {
  return AwesomeDialog(
    context: context,
    dialogType: type == "success"
        ? DialogType.SUCCES
        : type == "info"
            ? DialogType.INFO
            : type == "error"
                ? DialogType.ERROR
                : type == "warning"
                    ? DialogType.WARNING
                    : DialogType.NO_HEADER,
    animType: AnimType.BOTTOMSLIDE,
    title: mytitle,
    desc: mybody,
    btnCancelColor: type == "warning" ? Colors.orange[400] : Colors.red,
    btnCancelText: "موافق",
    btnCancelOnPress: () {},
  )..show();
}

showdialogall(context, String mytitle, String mycontent) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(mytitle),
          content: Text(mycontent),
          actions: <Widget>[
            FlatButton(
              child: Text("done"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}

showLoading(context) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("PLEASE WAIT"),
          content: Container(
              height: 50,
              child: Center(
                child: CircularProgressIndicator(),
              )),
        );
      });
}
