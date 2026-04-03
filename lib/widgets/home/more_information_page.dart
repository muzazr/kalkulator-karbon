import 'package:flutter/material.dart';

class MoreInformationPage extends StatelessWidget {
  final String title;
  final String overview;
  final String imagePath;
  final int hexColor;

  const MoreInformationPage({
    super.key,
    required this.title,
    required this.overview,
    required this.imagePath,
    required this.hexColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(hexColor).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(right: 15, left: 15),
      padding: const EdgeInsets.all(15),
      height: 150,
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(overview),
                  ],
                ),
                InkWell(
                  onTap: () {},
                  child: const Row(
                    children: [
                      Text(
                        'Selengkapnya',
                        style: TextStyle(
                          color: Color(0xFF018D58),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 17,
                        color: Color(0xFF018D58),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: SizedBox(
              width: 50,
              height: 100,
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
}

