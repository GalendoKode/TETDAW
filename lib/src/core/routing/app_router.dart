import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/login_view.dart';
import '../../features/home/presentation/home_view.dart';
import '../services/local_storage_service.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final localStorage = ref.watch(localStorageServiceProvider);
  
  // Initial check
  final isLoggedIn = localStorage.isSessionValid();
  if (!isLoggedIn) {
    // If invalid (expired or missing), ensure we clean up
    localStorage.deleteSession(); 
  }

  return GoRouter(
    initialLocation: isLoggedIn ? '/home' : '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeView(),
      ),
    ],
  );
});
