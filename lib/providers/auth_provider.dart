import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStatusProvider = StateProvider<bool>((ref) => false);
final authResultProvider = StateProvider<String?>((ref) => null);
