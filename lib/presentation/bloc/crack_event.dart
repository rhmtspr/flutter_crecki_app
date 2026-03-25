part of "crack_bloc.dart";

abstract class CrackDetectionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnImageCaptured extends CrackDetectionEvent {
  final File imageFile;

  OnImageCaptured(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}
