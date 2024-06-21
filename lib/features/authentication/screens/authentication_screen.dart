import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dio_sample/features/authentication/bloc/auth_bloc.dart';
import 'package:flutter_dio_sample/features/home/home_screen.dart';
import 'package:flutter_dio_sample/widgets/error_snackbar.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  var isSignUp = false;

  var email = '';
  var psw = '';
  var repeatPsw = '';
  var userName = '';
  var hidePsw = true;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
              (router) => false);
        }
        if (state is AuthError) {
          showFlashError(context, state.errorMsg);
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Stack(children: [
            // --- form -----
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isSignUp ? 'SIGN UP' : 'LOGIN',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        isSignUp
                            ? 'Register Yourself'
                            : 'Please signin to continue !',
                      ),
                      const Gap(20),
                      if (isSignUp) const Gap(20),
                      if (isSignUp)
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'User Name',
                              prefixIcon: const Icon(Iconsax.profile_2user),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide name';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            userName = newValue!;
                          },
                        ),
                      if (isSignUp) const Gap(20),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        validator: (value) {
                          if (!(value!.contains('@'))) {
                            return 'Email is Invalid';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          email = newValue!;
                        },
                      ),
                      const Gap(30),
                      TextFormField(
                        obscureText: hidePsw,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.password_outlined),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  hidePsw = !hidePsw;
                                });
                              },
                              child: Icon(
                                  hidePsw ? Iconsax.eye_slash : Iconsax.eye)),
                        ),
                        validator: (value) {
                          if ((value!.isEmpty || value.trim().length < 9)) {
                            return 'password  must be at least 9 characters';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          psw = newValue!;
                        },
                      ),
                      if (isSignUp) const Gap(20),
                      if (isSignUp)
                        TextFormField(
                          obscureText: hidePsw,
                          decoration: InputDecoration(
                            labelText: 'ReType Password',
                            prefixIcon: const Icon(Icons.password_outlined),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    hidePsw = !hidePsw;
                                  });
                                },
                                child: Icon(
                                    hidePsw ? Iconsax.eye_slash : Iconsax.eye)),
                          ),
                          validator: (value) {
                            if ((value!.isEmpty || value.trim().length < 9)) {
                              return 'password  must be at least 9 characters';
                            }

                            return null;
                          },
                          onSaved: (newValue) {
                            repeatPsw = newValue!;
                          },
                        ),
                      const Gap(10),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              if (psw != repeatPsw) {
                                showFlashError(
                                    context, 'Password donot match!');
                                return;
                              }

                              if (isSignUp) {
                                context.read<AuthBloc>().add(
                                    AuthSignUpButtonPressed(
                                        userName: userName,
                                        email: email,
                                        password: psw));
                                return;
                              }
                              context.read<AuthBloc>().add(
                                  AuthSignInButtonPressed(
                                      email: email, password: psw));
                            }
                          }, child: BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              if (state is AuthLoading) {
                                return const CircularProgressIndicator();
                              }
                              return Text(isSignUp ? 'SIGN UP' : 'LOGIN');
                            },
                          )))
                    ],
                  ),
                ),
              ),
            ),
            // ------ [signin/up text] / button
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(isSignUp
                        ? 'Already have an account !'
                        : 'Don\'t have account ?'),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            isSignUp = !isSignUp;
                            formKey.currentState!.reset();
                          });
                        },
                        child: Text(isSignUp ? 'Login' : 'Sign Up')),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
