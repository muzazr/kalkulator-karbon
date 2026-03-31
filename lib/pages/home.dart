import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

final StateProvider<int> carouselIndexProvider = StateProvider<int>((ref) => 0);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HeaderHomePage(),
            const CarouselHomePage(),
            const SizedBox(height: 20),
            const MoreInformationPage(
              title: 'Kamus Imbangi',
              overview:
                  'Temukan istilah seputar karbon dan keberlanjutan di sini',
              imagePath: 'assets/images/learning.png',
              hexColor: 0xFFFEFAF5,
            ),
            const SizedBox(height: 20),
            const MoreInformationPage(
              title: 'Sematkan Imbangi',
              overview: 'Integrasikan Kalkulator Karbon ke Platform Anda',
              imagePath: 'assets/images/tree.png',
              hexColor: 0xFFFEFAF5,
            ),
          ],
        ),
      ),
    );
  }
}

class MoreInformationPage extends StatelessWidget {
  final String title;
  final String overview;
  final String imagePath;
  final int hexColor;

  const MoreInformationPage({
    super.key,
    required this.title,
    required this.overview,
    required this.imagePath,
    required this.hexColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(hexColor).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(right: 15, left: 15),
      padding: const EdgeInsets.all(15),
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
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(overview),
                  ],
                ),
                InkWell(
                  onTap: () {},
                  child: const Row(
                    children: [
                      Text(
                        'Selengkapnya',
                        style: TextStyle(
                          color: Color(0xFF018D58),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 17,
                        color: Color(0xFF018D58),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: SizedBox(
              width: 50,
              height: 100,
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
}

class CarouselHomePage extends ConsumerWidget {
  const CarouselHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentIndex = ref.watch(carouselIndexProvider);
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          'Ayo hitung emisi karbon dari aktivitasmu!',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: 160.0,
            autoPlay: true,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              ref.read(carouselIndexProvider.notifier).state = index;
            },
          ),
          items: ['assets/images/carousel_1.png', 'assets/images/carousel_2.png']
              .map((img) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                img,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            );
          }).toList(),
        ),
        AnimatedSmoothIndicator(
          activeIndex: currentIndex,
          count: 2,
          effect: const ExpandingDotsEffect(dotHeight: 8, dotWidth: 8),
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: () => context.push('/features'),
          child: Container(
            height: 40,
            width: double.infinity,
            margin: const EdgeInsets.only(left: 15, right: 15),
            padding: const EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF018D58),
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(200, 0, 0, 0),
                  blurRadius: 3,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'Hitung Jejak Karbon',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HeaderHomePage extends StatelessWidget {
  const HeaderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: Color(0xFFFEFEFE),
        boxShadow: [
          BoxShadow(color: Colors.black, blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      child: const Row(
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
            radius: 20,
            backgroundColor: Color.fromARGB(208, 14, 93, 80),
            child: Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
