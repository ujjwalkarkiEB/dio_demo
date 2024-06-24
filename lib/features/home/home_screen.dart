import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dio_sample/features/authentication/bloc/auth_bloc.dart';

import '../authentication/screens/authentication_screen.dart';
import 'bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(HomeInitialDataFetchRequest()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Screen'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(AuthLogoutRequested());
              },
            ),
          ],
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLogout) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const AuthenticationScreen(),
                ),
                (route) => false,
              );
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeFetchLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HomeFetchSuccess) {
                if (state.posts.isEmpty) {
                  return const Center(
                      child: Text('No posts have been added yet!'));
                }
                return ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(state.posts[index]),
                    );
                  },
                );
              } else if (state is HomeFetchError) {
                return Center(child: Text(state.error));
              } else {
                return const Center(child: Text('Welcome to Home Screen'));
              }
            },
          ),
        ),
      ),
    );
  }
}
