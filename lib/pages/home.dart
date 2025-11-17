import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';

import 'select_feature.dart';

class HomePage extends StatelessWidget {
  final c = Get.put(CarouselGetXController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          // header
          HeaderHomePage(),
          CarouselHomePage(c: c), //plus CTA
          // card 1
          SizedBox(
            height: 20,
          ),
          MoreInformationPage(
              title: 'Kamus Imbangi',
              overview:
                  'Temukan istilah seputar karbon dan keberlanjutan di sini',
              imagePath: 'assets/images/learning.png',
              hexColor: 0xFFFEFAF5,
              ),
          // card 2
          SizedBox(
            height: 20,
          ),
          MoreInformationPage(
              title: 'Sematkan Imbangi',
              overview:
                  'Integrasikan Kalkulator Karbon ke Platform Anda',
              imagePath: 'assets/images/tree.png',
              hexColor: 0xFFFEFAF5,
              )
          // footer
        ],
      )),
    );
  }
}

class MoreInformationPage extends StatelessWidget {
  final String title;
  final String overview;
  final String imagePath;
  final int hexColor;

  const MoreInformationPage(
      {super.key,
      required this.title,
      required this.overview,
      required this.imagePath,
      required this.hexColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(hexColor).withOpacity(0.5),
        borderRadius: BorderRadius.circular(15)
      ),
      margin: EdgeInsets.only(right: 15, left: 15),
      padding: EdgeInsets.all(15),
      height: 150,
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700
                      ),
                    ), 
                    Text(overview)
                  ],
                ),
                InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Text(
                          'Selengkapnya',
                          style: TextStyle(
                            color: Color(0xFF018D58),
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        SizedBox(width: 10,),
                        Icon(
                          Icons.arrow_forward_ios_rounded, 
                          size: 17, 
                          color: Color(0xFF018D58),
                        )
                      ],
                    ))
              ],
            ),
          ),
          Expanded(
              flex: 4,
              child: SizedBox(
                  width: 50,
                  height: 100,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  )))
        ],
      ),
    );
  }
}

class CarouselHomePage extends StatelessWidget {
  const CarouselHomePage({
    super.key,
    required this.c,
  });

  final CarouselGetXController c;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          'Ayo hitung emisi karbon dari aktivitasmu!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500
          ),
        ),

        // carousel + CTA
        CarouselSlider(
            options: CarouselOptions(
              height: 160.0,
              // aspectRatio: 16 / 9,
              autoPlay: true,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                c.updateIndex(index);
              },
            ),
            items: [
              'assets/images/carousel_1.png',
              'assets/images/carousel_2.png',
            ].map((img) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  img,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              );
            }).toList()),

        Obx(() => AnimatedSmoothIndicator(
              activeIndex: c.currentIndex.value,
              count: 2,
              effect: ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
              ),
            )),

        SizedBox(
          height: 20,
        ),

        InkWell(
          onTap: () {
            Get.to(() => FeaturePage());
          },
          child: Container(
              height: 40,
              width: double.infinity,
              margin: EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              padding: EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                  color: Color(0xFF018D58),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: const Color.fromARGB(200, 0, 0, 0),
                        blurRadius: 3,
                        offset: Offset(2, 2))
                  ]),
              child: Center(
                child: Text(
                  'Hitung Jejak Karbon',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              )),
        )
      ],
    );
  }
}

class HeaderHomePage extends StatelessWidget {
  const HeaderHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'imbangi',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF0E5D50),
              fontWeight: FontWeight.w600,
            ),
          ),
          CircleAvatar(
            // backgroundImage: ,
            radius: 20,
            backgroundColor: Color.fromARGB(208, 14, 93, 80),
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.only(
          //     bottomLeft: Radius.circular(15),
          //     bottomRight: Radius.circular(15)),
          color: Color(0xFFFEFEFE),
          boxShadow: [
            BoxShadow(color: Colors.black, blurRadius: 3, offset: Offset(0, 1))
          ]),
    );
  }
}

class TopScreen {}

class CarouselGetXController extends GetxController {
  final CarouselController carouselController = CarouselController();
  RxInt currentIndex = 0.obs;

  void updateIndex(index) {
    currentIndex.value = index;
  }
}
