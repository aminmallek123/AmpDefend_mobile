class TeamMember {
  final String id;
  final String name;
  final String position;
  final String bio;
  final String imageUrl;
  final List<String> skills;
  final String email;
  final String? linkedIn;
  final String? twitter;

  const TeamMember({
    required this.id,
    required this.name,
    required this.position,
    required this.bio,
    required this.imageUrl,
    required this.skills,
    required this.email,
    this.linkedIn,
    this.twitter,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'] as String,
      name: json['name'] as String,
      position: json['position'] as String,
      bio: json['bio'] as String,
      imageUrl: json['imageUrl'] as String,
      skills: List<String>.from(json['skills'] as List),
      email: json['email'] as String,
      linkedIn: json['linkedIn'] as String?,
      twitter: json['twitter'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'bio': bio,
      'imageUrl': imageUrl,
      'skills': skills,
      'email': email,
      'linkedIn': linkedIn,
      'twitter': twitter,
    };
  }
}