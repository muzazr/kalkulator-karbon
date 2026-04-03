import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

final StateProvider<int> carouselIndexProvider = StateProvider<int>((ref) => 0);

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

