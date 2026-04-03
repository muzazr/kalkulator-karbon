import 'package:flutter/material.dart';

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

