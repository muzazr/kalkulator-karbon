import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project_based_learning_eco_apps/widgets/home/carousel_home_page.dart';
import 'package:project_based_learning_eco_apps/widgets/home/header_home_page.dart';
import 'package:project_based_learning_eco_apps/widgets/home/more_information_page.dart';

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
