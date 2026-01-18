import 'package:demo_app/viewModels/authentication_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool viewPassword = false;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Color.fromRGBO(17, 93, 104, 1.0)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Spacer(flex: 1),
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: 60),
                      Image(
                        image: AssetImage('assets/EzyCourse_logo.png'),
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 60),
                    ],
                  ),
                ),

                // Spacer(flex: 1),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(7, 81, 91, 1.0),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            fillColor: Color.fromRGBO(38, 105, 113, 1),
                            hintText: 'Enter your email...',
                            hintStyle: TextStyle(color: Colors.white38),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          style: TextStyle(color: Colors.white),
                          controller: passwordController,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  viewPassword = !viewPassword;
                                });
                                print("view: ${viewPassword}");
                              },
                              child: viewPassword
                                  ? Icon(
                                      Icons.visibility_off,
                                      color: Colors.white,
                                    )
                                  : Icon(
                                      Icons.visibility_rounded,
                                      color: Colors.white,
                                    ),
                            ),
                            fillColor: Color.fromRGBO(38, 105, 113, 1),
                            hintText: 'Enter your password...',
                            hintStyle: TextStyle(color: Colors.white38),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(
                            "Remember Me",
                            selectionColor: Colors.white,
                          ),
                          value: rememberMe,
                          onChanged: (bool? newValue) {
                            setState(() {
                              rememberMe = !rememberMe;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              print("login pressed");
                              ref
                                  .read(
                                    authenticationViewModelProvider.notifier,
                                  )
                                  .login(
                                    emailController.text,
                                    passwordController.text,
                                  );
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
