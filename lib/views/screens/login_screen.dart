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
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          width: double.infinity,
          decoration: BoxDecoration(color: Color.fromRGBO(17, 93, 104, 1.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Expanded(
              //   flex: 3,
              //   child: Column(
              //     crossAxisAlignment: .center,
              //     children: [
              //       Image(
              //         image: AssetImage('assets/EzyCourse_logo.png'),
              //         height: 120,
              //         fit: BoxFit.contain,
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                height: (screenHeight / 7) * 3,
                child: Center(
                  child: Image(
                    image: AssetImage('assets/EzyCourse_logo.png'),
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(7, 81, 91, 1.0),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(45),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5), // Shadow color
                        spreadRadius: 10, // How much the shadow spreads
                        blurRadius: 1, // How blurred the shadow is
                        offset: Offset(
                          -.1,
                          .1,
                        ), // Horizontal and vertical offset
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: .start,
                      children: [
                        Center(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Email',
                          style: TextStyle(color: Colors.white54, fontSize: 18),
                        ),
                        SizedBox(height: 6),
                        TextField(
                          style: TextStyle(color: Colors.white, fontSize: 18),
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
                        Text(
                          'Password',
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                        SizedBox(height: 6),
                        TextField(
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          controller: passwordController,
                          obscureText: viewPassword,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  viewPassword = !viewPassword;
                                });
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
                          contentPadding: EdgeInsets.zero,
                          side: BorderSide(color: Colors.white54, width: 1.5),

                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(
                            "Remember Me",
                            style: TextStyle(color: Colors.white),
                          ),
                          value: rememberMe,
                          onChanged: (bool? newValue) {
                            setState(() {
                              rememberMe = newValue ?? false;
                              print("rememberMe: ${rememberMe}");
                            });
                          },
                          activeColor: Color.fromRGBO(232, 245, 74, 1),
                          checkColor: Color.fromRGBO(7, 81, 91, 1.0),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(232, 245, 74, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                            onPressed: () {
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
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color.fromRGBO(38, 105, 113, 1),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
