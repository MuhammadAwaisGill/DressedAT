import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';

final authProvider = Provider((ref) => AuthRepository());
