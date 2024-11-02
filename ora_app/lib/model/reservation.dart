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
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      company: Company.fromJson(json['company']),
    );
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
      id: json['id'],
      name: json['name'],
      location: json['location'],
      totalRating: json['total_rating'],
    );
  }
}
