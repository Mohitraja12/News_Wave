import 'package:flutter/material.dart';

class ArticleDetailsPage extends StatelessWidget {
  final Map<String, dynamic> article;

  ArticleDetailsPage({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Displaying the article image
              article['urlToImage'] != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  article['urlToImage'],
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              )
                  : Container(
                height: 250,
                color: Colors.grey[300],
                child: Icon(Icons.image, color: Colors.grey[600]),
              ),
              SizedBox(height: 20),

              // Article Title
              Text(
                article['title'] ?? 'No title',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),

              // Article Description
              Text(
                article['description'] ?? 'No description available',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black.withOpacity(0.6),
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),

              // Full article content (use article['content'] if available)
              Text(
                article['content'] ?? 'No full content available.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),

              // External link (URL)
              article['url'] != null
                  ? GestureDetector(
                onTap: () {
                  // Optionally, open the URL in a browser
                },
                child: Text(
                  'Read full article',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}