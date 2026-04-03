import 'package:flutter/material.dart';
import 'package:project_based_learning_eco_apps/widgets/feature/calculator_category.dart';
import 'package:project_based_learning_eco_apps/widgets/feature/header_feature_page.dart';

class FeaturePage extends StatelessWidget {
  const FeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: [
            //header
            const HeaderFeaturePage(),

            //judul kategori kalkulator
            const SizedBox(height: 20),
            const Text(
              'Kategori Kalkulator',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),

            //kategorinya
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.2,
                children: [
                  const CalculatorCategory(
                    imagePath: 'assets/images/air_conditioner.png',
                    nameCategory: 'AC (Pendingin Ruangan)',
                    page: CalculatorPage.airConditioner,
                  ),
                  const CalculatorCategory(
                    imagePath: 'assets/images/fuel.png',
                    nameCategory: 'Bahan Bakar Industri',
                    page: CalculatorPage.fuelIndustry,
                  ),
                  const CalculatorCategory(
                    imagePath: 'assets/images/car.png',
                    nameCategory: 'Kendaraan',
                    page: CalculatorPage.vehicle,
                  ),
                  const CalculatorCategory(
                    imagePath: 'assets/images/lightbulb.png',
                    nameCategory: 'Peralatan Listrik',
                    page: CalculatorPage.electricTool,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
