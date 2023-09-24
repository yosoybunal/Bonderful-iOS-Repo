// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _isAuthenticating = false;
  List listOfQuestions = [];
  List listOfIntensities = [];

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'email': _enteredEmail,
          'password': _enteredPassword,
          'listQuestions': listOfQuestions,
          'listIntensities': listOfIntensities,
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in_use') {}
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed!'),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final heigth = MediaQuery.of(context).size.height * 0.80;
    final Uri urlPrivacy = Uri.parse(
        'https://docs.google.com/document/d/1FMDfZqAF93gZCWMs6F6jZQX9NN1K7qp94lNWnc8piHU/edit');

    Future<void> launchUrlPrivacy() async {
      if (!await launchUrl(urlPrivacy)) {
        throw Exception('Could not launch $urlPrivacy');
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 34, 34, 31),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: Image.asset(
                  'assets/images/bonderful1.png',
                  alignment: Alignment.center,
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: heigth,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.onInverseSurface,
                          Theme.of(context)
                              .colorScheme
                              .onInverseSurface
                              .withBlue(130),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            Card(
                              margin: const EdgeInsets.fromLTRB(20, 40, 20, 25),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        decoration: const InputDecoration(
                                          labelText: 'Email Address',
                                          icon: Icon(
                                            CupertinoIcons.mail_solid,
                                          ),
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        autocorrect: false,
                                        textCapitalization:
                                            TextCapitalization.none,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty ||
                                              !value.contains('@')) {
                                            return 'Please enter a valid email address!';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _enteredEmail = value!;
                                        },
                                      ),
                                      TextFormField(
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        decoration: const InputDecoration(
                                          labelText: 'Password',
                                          icon: Icon(CupertinoIcons.lock),
                                        ),
                                        obscureText: true,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().length < 6) {
                                            return 'Password should at least be 6 characters!';
                                          }
                                          if (value.trim().length > 10) {
                                            return 'Password should at most be 10 characters!';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _enteredPassword = value!;
                                        },
                                      ),
                                      const SizedBox(height: 17),
                                      if (_isAuthenticating)
                                        const CupertinoActivityIndicator(
                                            radius: 15.0,
                                            color: CupertinoColors.activeBlue),
                                      if (!_isAuthenticating)
                                        CupertinoButton.filled(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 15),
                                          onPressed: _submit,
                                          child: Text(
                                            _isLogin ? 'Login' : 'Signup',
                                            style:
                                                GoogleFonts.alef(fontSize: 18)
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .copyWith()
                                                            .colorScheme
                                                            .background),
                                          ),
                                        ),
                                      if (!_isAuthenticating)
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _isLogin = !_isLogin;
                                              FocusScope.of(context).unfocus();
                                            });
                                          },
                                          child: Text(
                                            _isLogin
                                                ? 'Create an account'
                                                : 'I already have an account',
                                            style:
                                                GoogleFonts.alef(fontSize: 15)
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .copyWith()
                                                            .colorScheme
                                                            .onBackground),
                                          ),
                                        ),
                                      if (!_isAuthenticating)
                                        TextButton(
                                          onPressed: () {
                                            launchUrlPrivacy();
                                          },
                                          child: RichText(
                                            text: TextSpan(
                                              text: 'Privacy Policy',
                                              style: GoogleFonts.alef(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Image.asset(
                                'assets/images/auth_screen_icon.png',
                                alignment: Alignment.center,
                                scale: 3.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
