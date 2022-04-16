part of 'gif_bloc.dart';

@immutable
abstract class GifEvent extends Equatable {
  const GifEvent();
}

class LoadGifEvent extends GifEvent {
  @override
  List<Object> get props => [];
}
