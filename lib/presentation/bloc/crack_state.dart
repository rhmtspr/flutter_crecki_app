part of "crack_bloc.dart";

class CrackDetectionState {}

class LoadingState extends CrackDetectionState {}

class LoadedState extends CrackDetectionState {
  final String result;
  final double confidence;

  LoadedState(this.result, this.confidence);
}

class ErrorState extends CrackDetectionState {}
