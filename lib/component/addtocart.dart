import 'package:flutter/material.dart';

class AddToCart with ChangeNotifier {
  List _itemsnoreapt = [];


  int countitems = 0; // For Count Items only

  double _price = 0;

  Map quantity = {};

  Map active = {};

  double _pricedelivery = 0;

  Map listpricedelivery = {};

  List listres = [];

  bool showalert = false;

  void add(items) {
    if (listres.isEmpty) {
      listres.add(items['res_id']);
    } else {}

    print("===========================");
    // print("$listres");
    // print(listres[0]);
    // print("-");
    // print(items['res_id']);

    List resault = listres.where((element) {
      print(element[0]);
      print(items['item_res']);
      if (int.parse(listres[0]) == int.parse(items['res_id'])) {
        return true ; 
      }
        return false ; 
    }).toList();

    if (resault.isNotEmpty) {
      showalert = false;

      // For Count
      countitems++;
      //

      active[items['item_id']] = 1;

      _price += double.parse(items['item_price'].toString());

      if (quantity[items['item_id']] == null ||
          quantity[items['item_id']] == 0) {
        _itemsnoreapt.add(items);

        quantity[items['item_id']] = 1;
      } else {
        quantity[items['item_id']] = quantity[items['item_id']] + 1;
      }

      if (listpricedelivery[items['res_id']] !=
          double.parse(items['res_id'].toString())) {
        listpricedelivery[items['res_id']] =
            int.parse(items['res_id'].toString());

        _pricedelivery += double.parse(items['res_price_delivery'].toString());
      }
    } else {
      showalert = true;
    }

    // print("===========================");
    // print(listres[0]);
    // print("-") ;
    // print(items['res_id']);
    print(items['res_id'] == listres[0]);
    print(resault);

    notifyListeners();
  }

  void remove(items) {
    if (quantity[items['item_id']] != null) {
      if (quantity[items['item_id']] == 1) {
        _itemsnoreapt
            .removeWhere((item) => item['item_id'] == items['item_id']);

        _itemsnoreapt.remove(items);

        active[items['item_id']] = 0;
      }

      if (quantity[items['item_id']] > 0) {
        // For Count
        countitems--;
        //

        _price -= double.parse(items['item_price'].toString());

        quantity[items['item_id']] = quantity[items['item_id']] - 1;

        var value = _itemsnoreapt
            .where((element) => element['res_id'] == items['res_id']);

        if (value.isEmpty) {
          listpricedelivery[items['res_id']] = 0;
          _pricedelivery -=
              double.parse(items['res_price_delivery'].toString());
          showalert = false;
          listres.clear();
        }
      }

      print(quantity);

      notifyListeners();
    }
  }

  void reset(items) {
    //  =====================================
    _itemsnoreapt.removeWhere((item) => item['item_id'] == items['item_id']);

    _price = _price -
        (double.parse(quantity[items['item_id']].toString()) *
            double.parse(items['item_price'].toString()));

    countitems -= quantity[items['item_id']];

    quantity[items['item_id']] = 0;

    // ===============

    active[items['item_id']] = 0;

    var value =
        _itemsnoreapt.where((element) => element['res_id'] == items['res_id']);

    if (value.isEmpty) {
      listpricedelivery[items['res_id']] = 0;

      _pricedelivery -= double.parse(items['res_price_delivery'].toString());

      listres.clear();

      showalert = false;
    }

    notifyListeners();
  }

  removeAll() {
    _itemsnoreapt.clear();
    _price = 0;
    quantity.clear();
    active.clear();
    listres.clear();
    _pricedelivery = 0;
    listpricedelivery.clear();
    countitems = 0;
  }

  double get totalprice {
    return _price;
  }

  List get basketnoreapt {
    return _itemsnoreapt;
  }

  double get totalpricedelivery {
    return _pricedelivery;
  }

  double get sumtotalprice {
    return _price + _pricedelivery;
  }

  int get count {
    return countitems;
  }

  // Color button change

}
