import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final String image;
  final int count;
  final int total_feeds; // total number of posts

  const CardWidget({
    super.key,
    required this.title,
    required this.image,
    required this.count,
    required this.total_feeds,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Expanded(
            flex: 1,
            child: Image(
              image: NetworkImage(image),
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Members: ${count}"),
                  Text('Posts: ${total_feeds}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
