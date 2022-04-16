import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pure/repositories/gif_repository.dart';

part 'gif_event.dart';
part 'gif_state.dart';

class GifBloc extends Bloc<GifEvent, GifState> {
  final GifRepository _jokeRepository;

  GifBloc(this._jokeRepository) : super(GifLoadingState()) {
    on<GifEvent>((event, emit) async {
      emit(GifLoadingState());
      try {
        final gifs = await _jokeRepository.getGifs();
        emit(GifLoadedState(gifs));
      } catch (e) {
        emit(GifErrorState(e.toString()));
      }
    });
  }
}
