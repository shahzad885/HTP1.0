import 'package:flutter/material.dart';

class Customcard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final DateTime? timestamp;
  final String publisherName;
  final VoidCallback onTap;
  final dynamic heroTag;
  final dynamic trailing;  // This will accept the trailing widget (like the favorite button)

  const Customcard({
    super.key,
    required this.heroTag,
    required this.title,
    required this.imageUrl,
    this.timestamp,
    required this.publisherName,
    required this.onTap,
    this.trailing,  // The trailing widget can be passed here
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 230,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: [
            // Left Side: Image
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.only(top: 40),
                  ),
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: imageUrl.isNotEmpty
                            ? Hero(
                                tag: heroTag,
                                child: Image.network(
                                  imageUrl,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.image,
                                size: 100,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Right Side: Blog Details
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 35, bottom: 30),
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        // Add the trailing widget here
                        if (trailing != null) trailing,
                      ],
                    ),
                    if (timestamp != null)
                      Text(
                        ' ${timestamp!.toLocal()}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    Text(
                      'Published by: $publisherName',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
