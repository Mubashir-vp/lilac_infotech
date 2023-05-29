import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

import '../../../core/data/services/http_services.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<DownloadVideo>((event, emit) async {
      try {
        emit(HomeLoading());
        Response response = await HttpServices().downloadVideo(event.uri);
        emit(
          VideoDownloaded(response: response),
        );
      } catch (e) {
        emit(
          FailedState(
            errorString: e.toString(),
          ),
        );
        log("Error occured $e");
      }
    });
  }
}
