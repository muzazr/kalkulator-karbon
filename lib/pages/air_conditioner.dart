import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_based_learning_eco_apps/widgets/air_conditioner/kapasitas_ac_dropdown.dart';
import 'package:project_based_learning_eco_apps/widgets/calculator_shared_widgets.dart';

final AutoDisposeChangeNotifierProvider<AcCalculatorController>
    acControllerProvider =
    ChangeNotifierProvider.autoDispose<AcCalculatorController>(
  (ref) => AcCalculatorController(),
);

class AirConditionerCalculator extends ConsumerWidget {
  const AirConditionerCalculator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AcCalculatorController controller = ref.watch(acControllerProvider);

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
                        'Air Conditioner',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    RichText(
                      text: const TextSpan(
                        text: 'Kapasitas AC (PK)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    KapasitasAC(
                      value: controller.selectedKapasitas,
                      onChanged: controller.updateKapasitas,
                    ),
                    const SizedBox(height: 20),
                    CalculatorTextField(
                      label: 'Jumlah Total Air Conditioner',
                      hint: 'Masukkan jumlah total air conditioner',
                      suffix: 'buah',
                      controller: controller.jumlahACController,
                      maxLength: 6,
                    ),
                    const SizedBox(height: 20),
                    CalculatorTextField(
                      label: 'Durasi',
                      hint: 'Masukkan durasi penggunaan',
                      suffix: 'Jam/Hari',
                      controller: controller.durasiACController,
                      maxLength: 6,
                    ),
                    const SizedBox(height: 20),
                    CalculatorTextField(
                      label: 'Total Hari Digunakan dalam Sebulan',
                      hint: 'Total Penggunaan dalam Sebulan',
                      suffix: 'Hari',
                      controller: controller.hariACController,
                      maxLength: 6,
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Kalkulasi yang digunakan sudah sesuai dengan jurnal dan literatur resmi.',
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

class AcCalculatorController extends ChangeNotifier {
  final TextEditingController jumlahACController = TextEditingController();
  final TextEditingController durasiACController = TextEditingController();
  final TextEditingController hariACController = TextEditingController();

  double? selectedKapasitas;
  double hasilCO2Harian = 0.0;
  double hasilCO2Mingguan = 0.0;
  double hasilCO2Bulanan = 0.0;
  String selectedTab = 'Hari';
  bool showResult = false;

  void updateKapasitas(double? value) {
    selectedKapasitas = value;
    notifyListeners();
  }

  void updateTab(String tab) {
    selectedTab = tab;
    notifyListeners();
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade600),
    );
  }

  void hitungJejakKarbon(BuildContext context) {
    final int? jumlahAC = int.tryParse(jumlahACController.text);
    final int? durasiAC = int.tryParse(durasiACController.text);
    final int? hariAC = int.tryParse(hariACController.text);

    if (selectedKapasitas == null ||
        jumlahAC == null ||
        durasiAC == null ||
        hariAC == null) {
      _showError(context, 'Semua field harus diisi!');
      return;
    }

    final double watt = selectedKapasitas! * 746;
    final double totalWh = watt * jumlahAC * durasiAC * hariAC;
    final double kWh = totalWh / 1000;
    final double co2Kg = kWh * 0.85;

    hasilCO2Harian = co2Kg / hariAC;
    hasilCO2Mingguan = hasilCO2Harian * 7;
    hasilCO2Bulanan = co2Kg;
    selectedTab = 'Hari';
    showResult = true;
    notifyListeners();
  }

  double get hasilCO2 {
    switch (selectedTab) {
      case 'Hari':
        return hasilCO2Harian;
      case 'Minggu':
        return hasilCO2Mingguan;
      case 'Bulan':
        return hasilCO2Bulanan;
      default:
        return 0.0;
    }
  }

  @override
  void dispose() {
    jumlahACController.dispose();
    durasiACController.dispose();
    hariACController.dispose();
    super.dispose();
  }
}
