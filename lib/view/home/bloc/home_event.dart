part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class DownloadVideo extends HomeEvent {
  final String uri;
  final String path;
  const DownloadVideo({required this.uri,required this.path});
  @override
  List<Object> get props => [];
}
