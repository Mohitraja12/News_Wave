import 'package:flutter/material.dart';
import 'package:newswave/Screens/details.dart';

Widget _buildNewsItem(Map<String, dynamic> article, BuildContext context) {
  return Card(
    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: InkWell(
      onTap: () {
        // Navigate to the details page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailsPage(article: article),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // News Image
              article['urlToImage'] != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  article['urlToImage'],
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              )
                  : Container(
                width: 120,
                height: 120,
                color: Colors.grey[300],
                child: Icon(Icons.image, color: Colors.grey[600]),
              ),
              SizedBox(width: 20),
              // News Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      article['description'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.6),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}