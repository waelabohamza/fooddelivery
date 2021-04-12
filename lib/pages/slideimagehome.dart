import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';



class SliderHome extends StatefulWidget {
  final imgList ; 
  SliderHome({this.imgList})  ; 
  @override
  _SliderHomeState createState() => _SliderHomeState();
}

class _SliderHomeState extends State<SliderHome> {
  int _currentIndex = 0;
 
  List cardList = [];

  addImageToList() {
    for (int x = 0; x < widget.imgList.length; x++) {
      cardList.add(ImageSlider(url: widget.imgList[x]));
    }
  }

  @override
  void initState() {
    addImageToList();
    super.initState();
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            height: 150.0,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            pauseAutoPlayOnTouch: true,
            aspectRatio: 2.0,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: cardList.map((card) {
            return Builder(builder: (BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: card,
                ),
              );
            });
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map<Widget>(cardList, (index, url) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.black : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class ImageSlider extends StatelessWidget {
  final url;
  const ImageSlider({Key key, this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(30)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: CachedNetworkImage(
            imageUrl: url,
            placeholder: (context, url) => Shimmer.fromColors(
                child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.grey,
                ),
                baseColor: Colors.grey,
                highlightColor: Colors.white),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.fill,
          ),
        ));
  }
}
