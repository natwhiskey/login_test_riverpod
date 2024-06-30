import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_service_provider.dart';

class AuthController {
  final ProviderRef<AuthController> ref;

  AuthController(this.ref);

  Future<void> login(String username, String password) async {
    final authService = ref.read(authServiceProvider);
    final success = await authService.login(username, password);
    if (success) {
      ref.read(authStatusProvider.notifier).update((state) => true);
      await fetchData();
    }
  }

  Future<void> fetchData() async {
    final authService = ref.read(authServiceProvider);
    final result = await authService.fetchData();
    ref.read(authResultProvider.notifier).update((state) => result);
  }
}



