class Outfit {
  final String id;
  final String userId;
  final String imageUrl;
  final String description;
  final String location;
  final String people;
  final DateTime date;

  const Outfit({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.description,
    required this.location,
    required this.people,
    required this.date,
  });

  factory Outfit.fromJson(Map<String, dynamic> json) {
    return Outfit(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      imageUrl: json['image_url'] as String,
      description: (json['description'] ?? '') as String,
      location: (json['location'] ?? '') as String,
      people: (json['people'] ?? '') as String,
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'image_url': imageUrl,
      'description': description,
      'location': location,
      'people': people,
      'date': date.toIso8601String(),
    };
  }

  // 🔥 Useful for updates later
  Outfit copyWith({
    String? id,
    String? userId,
    String? imageUrl,
    String? description,
    String? location,
    String? people,
    DateTime? date,
  }) {
    return Outfit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      location: location ?? this.location,
      people: people ?? this.people,
      date: date ?? this.date,
    );
  }
}
