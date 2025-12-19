import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'login_viewmodel.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;
  
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10));
    
    _topAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(tween: Tween(begin: Alignment.topLeft, end: Alignment.topRight), weight: 1),
      TweenSequenceItem(tween: Tween(begin: Alignment.topRight, end: Alignment.bottomRight), weight: 1),
      TweenSequenceItem(tween: Tween(begin: Alignment.bottomRight, end: Alignment.bottomLeft), weight: 1),
      TweenSequenceItem(tween: Tween(begin: Alignment.bottomLeft, end: Alignment.topLeft), weight: 1),
    ]).animate(_controller);

    _bottomAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(tween: Tween(begin: Alignment.bottomRight, end: Alignment.bottomLeft), weight: 1),
      TweenSequenceItem(tween: Tween(begin: Alignment.bottomLeft, end: Alignment.topLeft), weight: 1),
      TweenSequenceItem(tween: Tween(begin: Alignment.topLeft, end: Alignment.topRight), weight: 1),
      TweenSequenceItem(tween: Tween(begin: Alignment.topRight, end: Alignment.bottomRight), weight: 1),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginViewModelProvider);

    // Listen for state changes to navigate
    ref.listen<AsyncValue<void>>(loginViewModelProvider, (previous, next) {
      if (next is AsyncData) {
        context.go('/home');
      }
    });

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: const [
                  Color(0xFF198754), // Dark Green
                  Color(0xFF28a745), // Light Green
                  Color(0xFFF0F2F5), // White Grey
                ],
                begin: _topAlignmentAnimation.value,
                end: _bottomAlignmentAnimation.value,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo
                          Image.network(
                            'https://storage.googleapis.com/glide-prod.appspot.com/uploads-v2/1OSLd3wAUS6t5iLgLRFU/pub/IIbHFeIlpQUZ1ZYY6W4D.png',
                            height: 80,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 80, color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          
                          // Title
                          const Text(
                            'DAWALA',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          
                          // Subtitle
                          const Text(
                            'Data Warga & Layanan',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Input
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email Petugas',
                              prefixIcon: const Icon(Icons.email),
                              border: const UnderlineInputBorder(),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF28a745)),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          
                          // Error Message
                          if (loginState is AsyncError)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                loginState.error.toString().replaceAll('Exception: ', ''),
                                style: const TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                            
                          const SizedBox(height: 24),
                          
                          // Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: loginState is AsyncLoading
                                  ? null
                                  : () {
                                      final email = _emailController.text.trim();
                                      if (email.isNotEmpty) {
                                        ref.read(loginViewModelProvider.notifier).login(email);
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF28a745), // Solid Green
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                loginState is AsyncLoading ? 'Memverifikasi...' : 'Login Masuk',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
