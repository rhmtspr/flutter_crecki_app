import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cracky_app/domain/usecases/analyze_structural_damage.dart';

part "crack_event.dart";
part "crack_state.dart";

class CrackDetectionBloc extends Bloc<AnalyzeImageEvent, CrackDetectionState> {
  final AnalyzeStructuralDamage usecase;

  CrackDetectionBloc(this.usecase) : super(LoadingState()) {
    on<AnalyzeImageEvent>((event, emit) async {
      emit(LoadingState());

      try {
        final result = await usecase(event.image);

        emit(LoadedState(result.status, result.confidence));
      } catch (e) {
        emit(ErrorState());
      }
    });
  }
}
