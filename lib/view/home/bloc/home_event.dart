part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class DownloadVideo extends HomeEvent {
  final String uri;
  const DownloadVideo({required this.uri});
  @override
  List<Object> get props => [];
}
