part of 'gif_bloc.dart';

@immutable
abstract class GifState extends Equatable {}

class GifLoadingState extends GifState {
  @override
  List<Object?> get props => [];
}

class GifLoadedState extends GifState {
  final List gifModel;

  GifLoadedState(this.gifModel);

  @override
  List<Object?> get props => [gifModel];
}

class GifErrorState extends GifState {
  final String error;

  GifErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
