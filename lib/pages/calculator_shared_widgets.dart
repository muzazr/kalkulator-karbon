import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class FeatureCalculatorHeader extends StatelessWidget {
  const FeatureCalculatorHeader({super.key});

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
            onTap: () {
              Get.back();
            },
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

class CalculatorTextField extends StatelessWidget {
  final String label;
  final bool required;
  final String? hint;
  final String? suffix;
  final TextEditingController controller;
  final bool allowDecimal;
  final TextInputType keyboardType;
  final int? maxLength;

  const CalculatorTextField({
    super.key,
    required this.label,
    required this.controller,
    this.required = true,
    this.hint,
    this.suffix,
    this.allowDecimal = false,
    this.keyboardType = TextInputType.number,
    this.maxLength,
  });

  List<TextInputFormatter> _buildInputFormatters() {
    if (keyboardType != TextInputType.number) {
      return <TextInputFormatter>[
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
      ];
    }

    if (allowDecimal) {
      return <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
      ];
    }

    return <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly,
      if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
    ];
  }

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
          keyboardType: keyboardType,
          inputFormatters: _buildInputFormatters(),
          decoration: InputDecoration(
            hintText: hint ?? 'Masukkan $label',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            suffixText: suffix?.isEmpty == true ? null : suffix,
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

class CalculatorDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CalculatorDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
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
            children: const [
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
        DropdownButtonFormField<String>(
          initialValue: value,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF018D58), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Color(0xFF018D58), width: 1.5),
            ),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class CarbonResultCard extends StatelessWidget {
  final RxBool showResult;
  final RxString selectedTab;
  final RxDouble harian;
  final RxDouble mingguan;
  final RxDouble bulanan;

  const CarbonResultCard({
    super.key,
    required this.showResult,
    required this.selectedTab,
    required this.harian,
    required this.mingguan,
    required this.bulanan,
  });

  double _selectedValue(String tab) {
    switch (tab) {
      case 'Hari':
        return harian.value;
      case 'Minggu':
        return mingguan.value;
      case 'Bulan':
        return bulanan.value;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!showResult.value) {
        return const SizedBox.shrink();
      }

      final String activeTab = selectedTab.value;
      final double resultValue = _selectedValue(activeTab);

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
                '${resultValue.toStringAsFixed(2)} Kg CO2',
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
    });
  }

  Widget _buildTabButton(String tab) {
    return Obx(() {
      final bool isSelected = selectedTab.value == tab;

      return InkWell(
        onTap: () => selectedTab.value = tab,
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
    });
  }
}
