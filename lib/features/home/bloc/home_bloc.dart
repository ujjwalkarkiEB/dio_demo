import 'package:bloc/bloc.dart';
import 'package:flutter_dio_sample/utils/network/dio/dio_client.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialDataFetchRequest>(_onHomeInitialDataFetchRequest);
  }

  void _onHomeInitialDataFetchRequest(
      HomeInitialDataFetchRequest event, Emitter<HomeState> emit) async {
    emit(HomeFetchLoading());
    try {
      final response = await DioClient().client.get('post');
      final posts = response.data['data'];
      emit(HomeFetchSuccess(posts));
    } catch (error) {
      emit(HomeFetchError('Failed to fetch posts'));
    }
  }
}
