import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum CalculatorPage { airConditioner, fuelIndustry, vehicle, electricTool }

class CalculatorCategory extends StatelessWidget {
  final String imagePath;
  final String nameCategory;
  final CalculatorPage page;

  const CalculatorCategory({
    super.key,
    required this.imagePath,
    required this.nameCategory,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        switch (page) {
          case CalculatorPage.airConditioner:
            context.push('/calculator/air-conditioner');
            break;
          case CalculatorPage.fuelIndustry:
            context.push('/calculator/fuel-industry');
            break;
          case CalculatorPage.vehicle:
            context.push('/calculator/vehicle');
            break;
          case CalculatorPage.electricTool:
            context.push('/calculator/electric-tool');
            break;
        }
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        height: 95,
        width: 110,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color.fromARGB(255, 113, 110, 110),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: Image.asset(
                  imagePath,
                  height: 65,
                  width: 65,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  nameCategory,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: const TextStyle(fontSize: 13),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

