import 'package:fix_mates_user/view/worker_details_screen.dart';
import 'package:flutter/material.dart';

class GridItem extends StatelessWidget {
  final String? imagePath;
  final String? title;
  final String? category;

  const GridItem({
    Key? key,
    this.imagePath,
    this.title,
    this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: category != null
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ServiceProvidersScreen(category: category!),
                ),
              );
            }
          : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imagePath != null
                  ? Image.asset(
                      imagePath!,
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 30,
                      height: 30,
                      color: Colors.grey,
                    ),
            ),
          ),
          const SizedBox(height: 5),
          Flexible(
            child: Text(
              title ?? 'No title',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              maxLines: 2, // Allow up to two lines
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
