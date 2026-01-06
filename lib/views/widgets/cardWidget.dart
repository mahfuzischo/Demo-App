import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final String image;
  final int count;

  const CardWidget({
    super.key,
    required this.title,
    required this.image,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Image(image: NetworkImage(image), width: 50, fit: BoxFit.cover),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text("Members: ${count}"),
        ],
      ),
    );
  }
}
