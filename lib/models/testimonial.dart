class Testimonial {
  final String id;
  final String name;
  final String company;
  final String position;
  final String testimonial;
  final String avatarUrl;
  final int rating;
  final DateTime date;

  const Testimonial({
    required this.id,
    required this.name,
    required this.company,
    required this.position,
    required this.testimonial,
    required this.avatarUrl,
    required this.rating,
    required this.date,
  });

  factory Testimonial.fromJson(Map<String, dynamic> json) {
    return Testimonial(
      id: json['id'] as String,
      name: json['name'] as String,
      company: json['company'] as String,
      position: json['position'] as String,
      testimonial: json['testimonial'] as String,
      avatarUrl: json['avatarUrl'] as String,
      rating: json['rating'] as int,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'company': company,
      'position': position,
      'testimonial': testimonial,
      'avatarUrl': avatarUrl,
      'rating': rating,
      'date': date.toIso8601String(),
    };
  }
}