import 'package:flutter/material.dart';
import 'package:fooddelivery/pages/orderstaxi/orderstaxidone.dart';
import 'package:fooddelivery/pages/orderstaxi/orderstaxiwait.dart';

// My Import
class MyOrdersTaxi extends StatefulWidget {
  final initialpage;
  MyOrdersTaxi({Key key, this.initialpage}) : super(key: key);
  @override
  _MyOrdersTaxiState createState() => _MyOrdersTaxiState();
}

class _MyOrdersTaxiState extends State<MyOrdersTaxi> {
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
            BottomNavigationBarItem(
                icon: Icon(Icons.local_taxi), label: "قبل التوصيل"),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_taxi_outlined), label: "بعد التوصيل"),
          ],
          onTap: (current) {
            setState(() {
              selectedindex = current;
            });

            pageController.animateToPage(current,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
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
            children: [OrdersTaxiWait(), OrdersTaxiDone()]));
  }
}
