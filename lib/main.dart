import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dio_sample/features/authentication/bloc/auth_bloc.dart';
import 'package:flutter_dio_sample/features/authentication/screens/authentication_screen.dart';
import 'package:flutter_dio_sample/features/home/home_screen.dart';

import 'utils/network/helper/token_manager.dart';

void main() async {
  // Here binding authentication logic before app starts
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize TokenManager
  final tokenManager = TokenManager();

  // Check if access token exists
  final isAcessTokenPresent = await tokenManager.checkIfAccessTokenPresent();
  runApp(MyApp(isAcessTokenPresent: isAcessTokenPresent));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isAcessTokenPresent});
  final bool isAcessTokenPresent;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLogout) {
            // logging out user on failed accesstoken request
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const AuthenticationScreen(),
              ),
              (route) => false,
            );
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: isAcessTokenPresent
              ? const HomeScreen()
              : const AuthenticationScreen(),
        ),
      ),
    );
  }
}
