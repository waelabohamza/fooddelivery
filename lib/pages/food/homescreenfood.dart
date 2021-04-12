import 'package:flutter/material.dart';
import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/component/drawer.dart';
import 'package:fooddelivery/pages/categories/categories.dart';
import 'package:fooddelivery/pages/food/homefood.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';

class HomeScreenFood extends StatefulWidget {
  HomeScreenFood({Key key}) : super(key: key);

  @override
  _HomeScreenFoodState createState() => _HomeScreenFoodState();
}

class _HomeScreenFoodState extends State<HomeScreenFood> {
  PageController _pageController;
  Crud crud = new Crud();
  int _pageIndex = 0;
  List<Widget> tabPages = [
    HomeFood(),
    // Restaurants(),
    Categories(),
    // MyInformation()
  ];
  void onPageChanged(int page) {
    if (this.mounted) {
      setState(() {
        this._pageIndex = page;
      });
    }
  }

  void onTabTapped(int index) {
    this._pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: _pageIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: MyDrawer(),
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: _pageIndex,
        onTap: onTabTapped,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
        // fabLocation: BubbleBottomBarFabLocation.end, //new
        // hasNotch: true, //new
        // hasInk: true   , //new, gives a cute ink effect
        // inkColor: Colors.black12  , //optional, uses theme color if not specified
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                 Icons.home,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.home,
                color: Colors.red,
              ),
              title: Text("ماكولات")),
          // BubbleBottomBarItem(
          //     backgroundColor: Colors.indigo,
          //     icon: Icon(
          //       Icons.restaurant,
          //       color: Colors.black,
          //     ),
          //     activeIcon: Icon(
          //         Icons.restaurant,
          //       color: Colors.indigo,
          //     ),
          //     title: Text("المطاعم")),
          BubbleBottomBarItem(
              backgroundColor: Colors.green,
              icon: Icon(
                   Icons.category,
                color: Colors.black,
              ),
              activeIcon: Icon(
              Icons.category, 
                color: Colors.green,
              ),
              title: Text("المنيو")
              )
        ],
      ),
      body: PageView(
        children: tabPages,
        onPageChanged: onPageChanged,
        controller: _pageController,
        // physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:fooddelivery/component/crud.dart';
// import 'package:fooddelivery/component/drawer.dart';
// import 'package:fooddelivery/pages/categories/categories.dart';
// import 'package:fooddelivery/pages/food/homefood.dart';
// import 'package:fooddelivery/pages/restaurants/restaurants.dart';

// class HomeScreenFood extends StatefulWidget {
//   HomeScreenFood({Key key}) : super(key: key);

//   @override
//   _HomeScreenFoodState createState() => _HomeScreenFoodState();
// }

// class _HomeScreenFoodState extends State<HomeScreenFood> {
//   PageController _pageController;
//   Crud crud = new Crud();
//   int _pageIndex = 0;
//   List<Widget> tabPages = [
//     HomeFood(),
//     Restaurants(),
//     Categories(),
//     // MyInformation()
//   ];
//   void onPageChanged(int page) {
//     if (this.mounted) {
//       setState(() {
//         this._pageIndex = page;
//       });
//     }
//   }

//   void onTabTapped(int index) {
//     this._pageController.animateToPage(index,
//         duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
//   }

//   @override
//   void initState() {
//     _pageController = PageController(initialPage: _pageIndex);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double mdw = MediaQuery.of(context).size.width;
//     return  Scaffold(
//       drawer: MyDrawer(),
//         bottomNavigationBar: BottomNavigationBar(
//             currentIndex: _pageIndex,
//             onTap: onTabTapped,
//             backgroundColor:Colors.grey[50],
//             fixedColor: Colors.blue,
//             unselectedItemColor: Colors.black87,
//             type: BottomNavigationBarType.fixed,
//             items: [
//               BottomNavigationBarItem(
//                   icon: Icon(Icons.home), label: "الرئيسية"),
//               BottomNavigationBarItem(
//                   icon: Icon(Icons.restaurant), label: "المطاعم"),
//               BottomNavigationBarItem(
//                   icon: Icon(Icons.category), label: "الاقسام"),
//               // BottomNavigationBarItem(
//               //     icon: Icon(Icons.person), label: "معلوماتي"),
//             ]),
//         body: PageView(
//           children: tabPages,
//           onPageChanged: onPageChanged,
//           controller: _pageController,
//           // physics: NeverScrollableScrollPhysics(),
//         ),

//     );
//   }
// }
