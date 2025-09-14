class BlogPost {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String author;
  final DateTime publishDate;
  final String imageUrl;
  final List<String> tags;
  final int readTimeMinutes;
  final String category;

  const BlogPost({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.author,
    required this.publishDate,
    required this.imageUrl,
    required this.tags,
    required this.readTimeMinutes,
    required this.category,
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'] as String,
      title: json['title'] as String,
      excerpt: json['excerpt'] as String,
      content: json['content'] as String,
      author: json['author'] as String,
      publishDate: DateTime.parse(json['publishDate'] as String),
      imageUrl: json['imageUrl'] as String,
      tags: List<String>.from(json['tags'] as List),
      readTimeMinutes: json['readTimeMinutes'] as int,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'excerpt': excerpt,
      'content': content,
      'author': author,
      'publishDate': publishDate.toIso8601String(),
      'imageUrl': imageUrl,
      'tags': tags,
      'readTimeMinutes': readTimeMinutes,
      'category': category,
    };
  }

  String get formattedDate {
    return '${publishDate.day}/${publishDate.month}/${publishDate.year}';
  }
}