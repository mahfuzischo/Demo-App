import 'package:demo_app/viewModels/authentication_view_model.dart';
import 'package:demo_app/views/community_view.dart';
import 'package:demo_app/views/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationView extends ConsumerStatefulWidget {
  const AuthenticationView({super.key});

  @override
  ConsumerState<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends ConsumerState<AuthenticationView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authView = ref.watch(authenticationViewModelProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Auth screen"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: authView.isAuthenticated
            ? Center(
                child: Column(
                  children: [
                    Text("Hello ${authView.user?.email}"),

                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(builder: (context) => FeedView()),
                    //     );
                    //   },
                    //   child: Text('Feed page'),
                    // ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CommunityView();
                            },
                          ),
                        );
                      },
                      child: Text("Community Page"),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(authenticationViewModelProvider.notifier)
                            .logout();
                      },
                      child: Text("Logout"),
                    ),
                  ],
                ),
              )
            : LoginScreen(),
      ),
    );
  }
}
