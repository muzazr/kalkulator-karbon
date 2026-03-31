import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
            const HeaderFeaturePage(),
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
                    CustomTextField(
                      label: 'Jumlah Total Air Conditioner',
                      hint: 'Masukkan jumlah total air conditioner',
                      suffix: 'buah',
                      maxValue: 3,
                      minValue: 1,
                      maxLength: 6,
                      errorMessageEmpty: 'Wajib masukkan jumlah AC!',
                      controller: controller.jumlahACController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Durasi',
                      hint: 'Masukkan durasi penggunaan',
                      suffix: 'Jam/Hari',
                      maxValue: 24,
                      minValue: 1,
                      maxLength: 6,
                      errorMessageEmpty: 'Wajib masukkan durasi penggunaan AC!',
                      controller: controller.durasiACController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Total Hari Digunakan dalam Sebulan',
                      hint: 'Total Penggunaan dalam Sebulan',
                      suffix: 'Hari',
                      maxValue: 31,
                      minValue: 1,
                      maxLength: 6,
                      errorMessageEmpty: 'Wajib masukkan hari penggunaan AC!',
                      controller: controller.hariACController,
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
                    ResultCard(controller: controller),
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

class CustomTextField extends StatelessWidget {
  final String label;
  final bool required;
  final String? hint;
  final String suffix;
  final TextEditingController controller;
  final int maxLength;
  final int? minValue;
  final int? maxValue;
  final String? errorMessageEmpty;
  final String? errorMessageRange;

  const CustomTextField({
    super.key,
    required this.label,
    this.required = true,
    this.hint,
    required this.suffix,
    required this.controller,
    this.maxLength = 3,
    this.minValue,
    this.maxValue,
    this.errorMessageEmpty,
    this.errorMessageRange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            children: required
                ? const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(maxLength),
          ],
          decoration: InputDecoration(
            hintText: hint ?? 'Masukkan $label',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            suffixText: suffix,
            suffixStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF018D58), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Color(0xFF018D58), width: 1.7),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ],
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

class ResultCard extends StatelessWidget {
  final AcCalculatorController controller;

  const ResultCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (!controller.showResult) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF018D58), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jejak Karbonmu',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildTabButton('Hari')),
              const SizedBox(width: 8),
              Expanded(child: _buildTabButton('Minggu')),
              const SizedBox(width: 8),
              Expanded(child: _buildTabButton('Bulan')),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '${controller.hasilCO2.toStringAsFixed(2)} Kg CO2',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF018D58),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String tab) {
    final bool isSelected = controller.selectedTab == tab;
    return InkWell(
      onTap: () => controller.updateTab(tab),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF018D58) : Colors.white,
          border: Border.all(color: const Color(0xFF018D58), width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            tab,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF018D58),
            ),
          ),
        ),
      ),
    );
  }
}

class KapasitasAC extends StatelessWidget {
  final double? value;
  final ValueChanged<double?> onChanged;

  const KapasitasAC({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<double>(
      initialValue: value,
      decoration: InputDecoration(
        hintText: 'Pilih kapasitas',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF018D58), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF018D58), width: 1.5),
        ),
      ),
      items: [0.5, 0.75, 1.0, 1.5, 2.0, 2.5, 3.0]
          .map((pk) => DropdownMenuItem<double>(value: pk, child: Text('$pk')))
          .toList(),
      onChanged: onChanged,
    );
  }
}

class HeaderFeaturePage extends StatelessWidget {
  const HeaderFeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFEFEFE),
        boxShadow: [
          BoxShadow(blurRadius: 2, offset: Offset(0, 1), color: Colors.black)
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          InkWell(
            onTap: () => context.go('/features'),
            child: const Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 0, 0, 0),
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          const Text(
            'Kalkulator Jejak Karbon',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ],
      ),
    );
  }
}
