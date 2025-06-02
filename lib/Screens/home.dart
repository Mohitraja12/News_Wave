import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _newsArticles = [];
  final String apiKey = '7b692cc750f44acc91f718fa1157e896'; // Your API key
  final String baseUrl = 'https://newsapi.org/v2';
  bool _isLoading = false;
  String _errorMessage = "";
  String _currentCategory = 'tesla'; // Default category

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews({String query = 'tesla'}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/everything?q=$query&sortBy=publishedAt&apiKey=$apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _newsArticles = data['articles'] != null
              ? data['articles']
              .where((article) =>
          article['urlToImage'] != null &&
              article['urlToImage'] != '')
              .toList()
              : [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load news: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching news: $e';
        _isLoading = false;
      });
      print('Error fetching news: $e');
    }
  }

  Widget _buildCarouselSlider() {
    final topNews = _newsArticles.take(5).toList();
    return topNews.isEmpty
        ? SizedBox.shrink()
        : CarouselSlider(
      options: CarouselOptions(
        height: 250.0,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        aspectRatio: 16 / 9,
      ),
      items: topNews.map((article) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(article['urlToImage'] ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 10,
                    right: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article['title'] ?? 'No title',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Text(
                          article['description'] ?? '',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white70,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }

  void _showNewsDetails(Map<String, dynamic> article) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            height: 500,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      article['urlToImage'] ??
                          'https://via.placeholder.com/150',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    article['title'] ?? 'No title',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    article['description'] ?? 'No description available.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  final List<String> categories = [
    "tesla",
    "sports",
    "politics",
    "technology",
    "business",
    "entertainment"
  ];

  final List<String> categoryDisplayNames = [
    "General",
    "Sports",
    "Politics",
    "Technology",
    "Business",
    "Entertainment"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NewsWave'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                categories.length,
                    (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentCategory = categories[index];
                    });
                    _fetchNews(query: categories[index]);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    padding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _currentCategory == categories[index]
                          ? Colors.blueAccent
                          : Colors.white,
                      border: Border.all(
                        color: _currentCategory == categories[index]
                            ? Colors.blueAccent
                            : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      categoryDisplayNames[index],
                      style: TextStyle(
                        color: _currentCategory == categories[index]
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          _buildCarouselSlider(),
          SizedBox(height: 10),
          Expanded(
            child: _newsArticles.isEmpty
                ? Center(
              child: Text(
                _errorMessage.isNotEmpty
                    ? _errorMessage
                    : 'No articles available.',
                textAlign: TextAlign.center,
              ),
            )
                : ListView.builder(
              itemCount: _newsArticles.length,
              itemBuilder: (context, index) {
                final article = _newsArticles[index];
                return _buildNewsItem(article, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(Map<String, dynamic> article, BuildContext context) {
    return GestureDetector(
      onTap: () => _showNewsDetails(article),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                article['urlToImage'] != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    article['urlToImage'],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image,
                          color: Colors.grey[600]),
                    ),
                  ),
                )
                    : Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: Icon(Icons.image, color: Colors.grey[600]),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article['title'] ?? 'No title',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        article['description'] ?? 'No description',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.6),
                        ),
                        maxLines: 2,
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
}