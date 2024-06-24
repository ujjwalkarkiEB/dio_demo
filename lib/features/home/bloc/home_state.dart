part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeFetchLoading extends HomeState {}

class HomeFetchSuccess extends HomeState {
  final List<dynamic> posts;
  HomeFetchSuccess(this.posts);
}

class HomeFetchError extends HomeState {
  final String error;
  HomeFetchError(this.error);
}
