import 'package:barcode_scan/barcode_scan.dart';

scanQrCode() async {
  var options = ScanOptions();
  var result = await BarcodeScanner.scan(options: options);
  print(
      "resualt QrCode  ===================================================================");
  print(result.type);
  if (result.type.toString() == "Cancelled") {
    print("yes cancel");
    return "cancel" ; 
  }
  if (result.type.toString() == "Barcode") {
    print("yes barcode");
    return result.rawContent;
  }
   return "faild" ; 
}

/*
   
            QrImage(
            data: "wael",
            version: QrVersions.auto,
            size: 200.0,
          ),

  */
