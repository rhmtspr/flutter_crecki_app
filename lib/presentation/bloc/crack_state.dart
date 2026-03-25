part of "crack_bloc.dart";

abstract class CrackDetectionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DetectionInitial extends CrackDetectionState {}

class DetectionLoading extends CrackDetectionState {}

class DetectionSuccess extends CrackDetectionState {
  final CrackResult result;

  DetectionSuccess({required this.result});

  @override
  List<Object?> get props => [result];
}

class DetectionFailure extends CrackDetectionState {
  final String errorMessage;

  DetectionFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
