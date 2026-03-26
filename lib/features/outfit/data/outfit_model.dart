class Outfit {
  final String id;
  final String userId;
  final String imageUrl;
  final String description;
  final String location;
  final String people;
  final DateTime date;
  final String? topColor;
  final String? bottomType;
  final String? outfitType;
  final String? colorTheme;

  Outfit({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.description,
    required this.location,
    required this.people,
    required this.date,
    this.topColor,
    this.bottomType,
    this.outfitType,
    this.colorTheme,
  });

  factory Outfit.fromJson(Map<String, dynamic> json) {
    return Outfit(
      id: json['id'],
      userId: json['user_id'],
      imageUrl: json['image_url'],
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      people: json['people'] ?? '',
      date: DateTime.parse(json['date']),
      topColor: json['top_color'],
      bottomType: json['bottom_type'],
      outfitType: json['outfit_type'],
      colorTheme: json['color_theme'],
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
      'top_color': topColor,
      'bottom_type': bottomType,
      'outfit_type': outfitType,
      'color_theme': colorTheme,
    };
  }
}