class Feature {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final List<String> benefits;
  final String category;
  final bool isHighlighted;

  const Feature({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.benefits,
    required this.category,
    this.isHighlighted = false,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconPath: json['iconPath'] as String,
      benefits: List<String>.from(json['benefits'] as List),
      category: json['category'] as String,
      isHighlighted: json['isHighlighted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconPath': iconPath,
      'benefits': benefits,
      'category': category,
      'isHighlighted': isHighlighted,
    };
  }
}