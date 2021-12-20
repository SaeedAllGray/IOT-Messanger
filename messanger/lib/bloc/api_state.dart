part of 'api_bloc.dart';

@immutable
abstract class ApiState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingState extends ApiState {}

class SendingMessageInProgress extends ApiState {}

class MessagesLoaded extends ApiState {
  final List<String> messages;

  MessagesLoaded(this.messages);

  @override
  List<Object?> get props => [this.messages];
}

class PinsValueLoaded extends ApiState {
  final List<PinsData> data;

  PinsValueLoaded(this.data);

  @override
  List<Object?> get props => [this.data];
}
