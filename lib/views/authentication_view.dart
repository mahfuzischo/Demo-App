import 'package:demo_app/viewModels/authentication_view_model.dart';
import 'package:demo_app/views/community_view.dart';
import 'package:demo_app/views/screens/login_screen.dart';
import 'package:demo_app/views/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationView extends ConsumerStatefulWidget {
  const AuthenticationView({super.key});

  @override
  ConsumerState<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends ConsumerState<AuthenticationView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authView = ref.watch(authenticationViewModelProvider);
    return Scaffold(
      body: authView.isAuthenticated ? BottomNavbar() : LoginScreen(),
    );
  }
}
