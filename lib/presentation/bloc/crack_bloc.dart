import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cracky_app/domain/entities/crack_result.dart';
import 'package:flutter_cracky_app/domain/repositories/crack_repository.dart';

part "crack_event.dart";
part "crack_state.dart";

class CrackDetectionBloc
    extends Bloc<CrackDetectionEvent, CrackDetectionState> {
  final CrackRepository repository;

  CrackDetectionBloc({required this.repository}) : super(DetectionInitial()) {
    // Menangani event saat gambar masuk
    on<OnImageCaptured>((event, emit) async {
      // 1. Tampilkan indikator loading di UI
      emit(DetectionLoading());

      try {
        // 2. Jalankan analisis melalui repository
        final result = await repository.detectCrack(event.imageFile);

        // 3. Jika berhasil, kirim state sukses beserta datanya
        emit(DetectionSuccess(result: result));
      } catch (e) {
        // 4. Jika gagal (misal: memori penuh atau file korup)
        emit(DetectionFailure(errorMessage: e.toString()));
      }
    });
  }
}
