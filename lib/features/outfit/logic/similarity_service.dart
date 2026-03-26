import '../data/outfit_model.dart';

class SimilarityService {
  List<Outfit> findSimilar(Outfit newOutfit, List<Outfit> history) {
    return history.where((old) {
      int score = 0;

      if (_match(old.description, newOutfit.description)) score++;
      if (_match(old.location, newOutfit.location)) score++;
      if (_match(old.people, newOutfit.people)) score++;

      return score >= 2;
    }).toList();
  }

  bool _match(String a, String b) {
    if (a.isEmpty || b.isEmpty) return false;

    final wordsA = a.toLowerCase().split(RegExp(r'\W+'));
    final wordsB = b.toLowerCase().split(RegExp(r'\W+'));

    return wordsA.any((w) => w.length > 3 && wordsB.contains(w));
  }
}
