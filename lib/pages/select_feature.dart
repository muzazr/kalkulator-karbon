import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_based_learning_eco_apps/pages/home.dart';

import 'air_conditioner.dart';
import 'electric_area.dart';
import 'electric_tool.dart';
import 'fuel_industry.dart';
import 'vehicle.dart';

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
            HeaderFeaturePage(),

            //judul kategori kalkulator
            SizedBox(
              height: 20,
            ),
            Text(
              'Kategori Kalkulator',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),

            //kategorinya
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 15,
                runSpacing: 15,
                children: [
                  CalculatorCategory(
                      imagePath: 'assets/images/air_conditioner.png',
                      nameCategory: 'AC (Pendingin Ruangan)',
                      page: CalculatorPage.airConditioner,
                      ),
                  CalculatorCategory(
                      imagePath: 'assets/images/fuel.png',
                      nameCategory: 'Bahan Bakar Industri',
                      page: CalculatorPage.fuelIndustry,
                      ),
                  CalculatorCategory(
                      imagePath: 'assets/images/car.png',
                      nameCategory: 'Kendaraan',
                      page: CalculatorPage.vehicle,
                      ),
                  CalculatorCategory(
                      imagePath: 'assets/images/electric_factory.png',
                      nameCategory: 'Konsumsi Wilayah Listrik',
                      page: CalculatorPage.electricArea,
                      ),
                  CalculatorCategory(
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

class HeaderFeaturePage extends StatelessWidget {
  const HeaderFeaturePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xFFFEFEFE), boxShadow: [
        BoxShadow(blurRadius: 2, offset: Offset(0, 1), color: Colors.black)
      ]),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.to(() => HomePage());
            },
            child: Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 0, 0, 0),
              size: 30,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            'Kalkulator Jejak Karbon',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color.fromARGB(255, 0, 0, 0)),
          )
        ],
      ),
    );
  }
}

enum CalculatorPage {
  airConditioner,
  fuelIndustry,
  vehicle,
  electricArea,
  electricTool
}

void navigateTo(CalculatorPage page) {
  // final Map<String, Widget Function()> pageMap = {
  //   "air_conditioner": () => AirConditionerCalculator(),
  // };

  // final pageBuilder = pageMap[pageCalculator];
  // Get.to(() => pageBuilder!());

  switch (page) {
    case CalculatorPage.airConditioner:
      Get.to(() => AirConditionerCalculator());
      break;
    case CalculatorPage.electricArea:
      Get.to(() => ElectricArea());
      break;
    case CalculatorPage.electricTool:
      Get.to(() => ElectricTool());
      break;
    case CalculatorPage.fuelIndustry:
      Get.to(() => FuelIndustry());
    case CalculatorPage.vehicle:
      Get.to(() => Vehicle());
  }
}

class CalculatorCategory extends StatelessWidget {
  final String imagePath;
  final String nameCategory;
  final CalculatorPage page;

  const CalculatorCategory(
      {super.key, required this.imagePath, required this.nameCategory, required this.page});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Get.to(() => );
        navigateTo(page);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        height: 95,
        width: 110,
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color: const Color.fromARGB(255, 113, 110, 110), width: 1.5)),
        child: Center(
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: Image.asset(
                  imagePath,
                  height: 50,
                  width: 50,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  nameCategory,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(fontSize: 10),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
