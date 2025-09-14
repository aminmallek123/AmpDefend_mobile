class ContactRequest {
  final String name;
  final String email;
  final String company;
  final String message;
  final ContactType type;
  final DateTime submittedAt;

  const ContactRequest({
    required this.name,
    required this.email,
    required this.company,
    required this.message,
    required this.type,
    required this.submittedAt,
  });

  factory ContactRequest.fromJson(Map<String, dynamic> json) {
    return ContactRequest(
      name: json['name'] as String,
      email: json['email'] as String,
      company: json['company'] as String,
      message: json['message'] as String,
      type: ContactType.values.firstWhere(
        (e) => e.toString() == 'ContactType.${json['type']}',
      ),
      submittedAt: DateTime.parse(json['submittedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'company': company,
      'message': message,
      'type': type.toString().split('.').last,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }
}

enum ContactType {
  demo,
  general,
  support,
  partnership,
}