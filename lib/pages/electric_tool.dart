import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project_based_learning_eco_apps/widgets/calculator_shared_widgets.dart';

final AutoDisposeChangeNotifierProvider<ElectricToolCalculatorController>
    electricToolControllerProvider =
    ChangeNotifierProvider.autoDispose<ElectricToolCalculatorController>(
  (ref) => ElectricToolCalculatorController(),
);

class ElectricTool extends ConsumerWidget {
  const ElectricTool({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ElectricToolCalculatorController controller =
        ref.watch(electricToolControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FeatureCalculatorHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    const Center(
                      child: Text(
                        'Peralatan Listrik',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    CalculatorTextField(
                      label: 'Nama peralatan',
                      hint: 'Masukkan nama peralatan',
                      controller: controller.namaPeralatanController,
                      keyboardType: TextInputType.text,
                      maxLength: 50,
                    ),
                    const SizedBox(height: 20),
                    CalculatorTextField(
                      label: 'Daya listrik (Watt)',
                      hint: 'Masukkan daya listrik',
                      suffix: 'W',
                      controller: controller.dayaWattController,
                      allowDecimal: true,
                      maxLength: 12,
                    ),
                    const SizedBox(height: 20),
                    CalculatorTextField(
                      label: 'Jumlah unit',
                      hint: 'Masukkan jumlah unit',
                      suffix: 'unit',
                      controller: controller.jumlahUnitController,
                      maxLength: 6,
                    ),
                    const SizedBox(height: 20),
                    CalculatorTextField(
                      label: 'Durasi pemakaian per hari',
                      hint: 'Masukkan durasi pemakaian',
                      suffix: 'jam',
                      controller: controller.jamPerHariController,
                      allowDecimal: true,
                      maxLength: 5,
                    ),
                    const SizedBox(height: 20),
                    CalculatorTextField(
                      label: 'Hari digunakan dalam sebulan',
                      hint: 'Masukkan hari penggunaan',
                      suffix: 'hari',
                      controller: controller.hariPerBulanController,
                      maxLength: 2,
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Perhitungan emisi menggunakan total konsumsi kWh bulanan dengan faktor emisi listrik 0.85.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CarbonResultCard(
                      showResult: controller.showResult,
                      selectedTab: controller.selectedTab,
                      harian: controller.hasilCO2Harian,
                      mingguan: controller.hasilCO2Mingguan,
                      bulanan: controller.hasilCO2Bulanan,
                      onTabChanged: controller.updateTab,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.hitungJejakKarbon(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF018D58),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Hitung',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ElectricToolCalculatorController extends ChangeNotifier {
  final TextEditingController namaPeralatanController = TextEditingController();
  final TextEditingController dayaWattController = TextEditingController();
  final TextEditingController jumlahUnitController = TextEditingController();
  final TextEditingController jamPerHariController = TextEditingController();
  final TextEditingController hariPerBulanController = TextEditingController();

  double hasilCO2Harian = 0.0;
  double hasilCO2Mingguan = 0.0;
  double hasilCO2Bulanan = 0.0;
  String selectedTab = 'Hari';
  bool showResult = false;

  void updateTab(String tab) {
    selectedTab = tab;
    notifyListeners();
  }

  double? _parseNumber(String value) {
    return double.tryParse(value.trim().replaceAll(',', '.'));
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade600),
    );
  }

  void hitungJejakKarbon(BuildContext context) {
    final String namaPeralatan = namaPeralatanController.text.trim();
    final String dayaWattText = dayaWattController.text.trim();
    final String jumlahUnitText = jumlahUnitController.text.trim();
    final String jamPerHariText = jamPerHariController.text.trim();
    final String hariPerBulanText = hariPerBulanController.text.trim();

    if (namaPeralatan.isEmpty ||
        dayaWattText.isEmpty ||
        jumlahUnitText.isEmpty ||
        jamPerHariText.isEmpty ||
        hariPerBulanText.isEmpty) {
      _showError(context, 'Semua field harus diisi!');
      return;
    }

    final double? dayaWatt = _parseNumber(dayaWattText);
    final int? jumlahUnit = int.tryParse(jumlahUnitText);
    final double? jamPerHari = _parseNumber(jamPerHariText);
    final int? hariPerBulan = int.tryParse(hariPerBulanText);

    if (dayaWatt == null ||
        jumlahUnit == null ||
        jamPerHari == null ||
        hariPerBulan == null) {
      _showError(context, 'Angka yang dimasukkan tidak valid.');
      return;
    }

    if (dayaWatt <= 0) {
      _showError(context, 'Daya listrik harus lebih dari 0.');
      return;
    }

    if (jumlahUnit < 1) {
      _showError(context, 'Jumlah unit minimal 1.');
      return;
    }

    if (jamPerHari <= 0 || jamPerHari > 24) {
      _showError(context, 'Jam per hari harus lebih dari 0 dan maksimal 24.');
      return;
    }

    if (hariPerBulan < 1 || hariPerBulan > 31) {
      _showError(context, 'Hari per bulan harus antara 1 sampai 31.');
      return;
    }

    final double totalWhBulanan =
        dayaWatt * jumlahUnit * jamPerHari * hariPerBulan;
    final double kWhBulanan = totalWhBulanan / 1000;
    final double emisiBulanan = kWhBulanan * 0.85;
    final double emisiHarian = emisiBulanan / hariPerBulan;
    final double emisiMingguan = emisiHarian * 7;

    hasilCO2Harian = emisiHarian;
    hasilCO2Mingguan = emisiMingguan;
    hasilCO2Bulanan = emisiBulanan;
    selectedTab = 'Hari';
    showResult = true;
    notifyListeners();
  }

  @override
  void dispose() {
    namaPeralatanController.dispose();
    dayaWattController.dispose();
    jumlahUnitController.dispose();
    jamPerHariController.dispose();
    hariPerBulanController.dispose();
    super.dispose();
  }
}
