class Reservation {
  final int id;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final Company company;

  Reservation({
    required this.id,
    required this.createdAt,
    this.deletedAt,
    required this.company,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
      company: Company.fromJson(json['company'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'company': company.toJson(),
    };
  }
}

class Company {
  final int id;
  final String name;
  final String location;
  final int totalRating;

  Company({
    required this.id,
    required this.name,
    required this.location,
    required this.totalRating,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] as int,
      name: json['name'] as String,
      location: json['location'] as String,
      totalRating: json['total_rating'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'total_rating': totalRating,
    };
  }
}
