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
  // await tokenManager.clearTokens();

  // Check if token exists
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
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: isAcessTokenPresent
            ? const HomeScreen()
            : const AuthenticationScreen(),
      ),
    );
  }
}
