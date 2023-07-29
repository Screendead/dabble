import 'package:dabble/widgets/log_in.dart';
import 'package:dabble/widgets/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final logInForm = GlobalKey<FormState>();
  final signUpForm = GlobalKey<FormState>();
  final email = GlobalKey<FormFieldState<String>>();
  final password = GlobalKey<FormFieldState<String>>();
  final passwordConfirm = GlobalKey<FormFieldState<String>>();

  bool isLogIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SizedBox(
            width: 400,
            child: isLogIn
                ? LogIn(
                    formKey: logInForm,
                    email: email,
                    password: password,
                    submit: () async {
                      ScaffoldMessengerState messenger =
                          ScaffoldMessenger.of(context);

                      if (logInForm.currentState!.validate()) {
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text('Processing Data'),
                          ),
                        );

                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: email.currentState!.value!,
                            password: password.currentState!.value!,
                          );
                        } on FirebaseAuthException catch (e) {
                          messenger.removeCurrentSnackBar();
                          String message;

                          switch (e.code) {
                            case 'user-not-found':
                            case 'wrong-password':
                              message = 'Username or password is incorrect.';
                              break;
                            default:
                              message =
                                  'An error occurred. Please try again later.';
                              break;
                          }

                          messenger.showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(message),
                            ),
                          );
                          return;
                        }

                        messenger.removeCurrentSnackBar();
                        messenger.showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                              'Logged in successfully.',
                            ),
                          ),
                        );
                      }
                    },
                    toggle: () {
                      setState(() {
                        isLogIn = false;
                      });
                    },
                  )
                : SignUp(
                    formKey: signUpForm,
                    email: email,
                    password: password,
                    passwordConfirm: passwordConfirm,
                    submit: () async {
                      ScaffoldMessengerState messenger =
                          ScaffoldMessenger.of(context);

                      if (signUpForm.currentState!.validate()) {
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text('Processing Data'),
                          ),
                        );

                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email.currentState!.value!,
                            password: password.currentState!.value!,
                          );
                        } on FirebaseAuthException catch (e) {
                          messenger.removeCurrentSnackBar();
                          String message;

                          switch (e.code) {
                            case 'email-already-in-use':
                              message = 'Email is already in use.';
                              break;
                            default:
                              message =
                                  'An error occurred. Please try again later.';
                              break;
                          }

                          messenger.showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(message),
                            ),
                          );
                          return;
                        }

                        messenger.removeCurrentSnackBar();
                        messenger.showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                              'Account created successfully.',
                            ),
                          ),
                        );
                      }
                    },
                    toggle: () {
                      setState(() {
                        isLogIn = true;
                      });
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
