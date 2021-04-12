import 'package:flutter/material.dart';
import 'package:fooddelivery/pages/orders/ordersdone.dart';
import 'package:fooddelivery/pages/orders/ordersproccess.dart';
import 'package:fooddelivery/pages/orders/orderswait.dart';

// My Import
class MyOrders extends StatefulWidget {
  final initialpage;
  MyOrders({Key key, this.initialpage}) : super(key: key);
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  int currentpage = 0;
  int selectedindex;

  PageController pageController;

  @override
  void initState() {
    pageController = PageController(
      initialPage: widget.initialpage != null ? 1 : 0,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.delivery_dining ), label: "بانتظار الموافقة"),
            BottomNavigationBarItem(icon: Icon(Icons.delivery_dining ), label: "قيد الانجاز"),
            BottomNavigationBarItem(icon: Icon(Icons.delivery_dining ), label: "ارشيف الطلبات"),
          ],
          onTap: (current) {
            setState(() {
              selectedindex = current;
            });
          
            // pageController.animateToPage(current,
            //     duration: const Duration(milliseconds: 500),
            //     curve: Curves.easeInOut);
            pageController.jumpToPage(current) ; 
          },
          selectedItemColor: Colors.brown,
          currentIndex: currentpage,
        ),
        body: PageView(
            controller: pageController,
            onPageChanged: (val) {
              setState(() {
                currentpage = val;
              });
            },
            children: [OrdersWait(),  OrdersProccess() , OrdersDone()]));
  }
}
