part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class VideoDownloaded extends HomeState {
  final Response response;
  const VideoDownloaded({
    required this.response,
  });
  @override
  List<Object> get props => [response];
}

class FailedState extends HomeState {
  final String errorString;
  const FailedState({
    required this.errorString,
  });
  @override
  List<Object> get props => [errorString];
}
