part of 'api_bloc.dart';

@immutable
abstract class ApiEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetMessagesEvent extends ApiEvent {
  final Uuid uuid = Uuid();
  @override
  List<Object?> get props => [uuid];
}

class SendMessageEvent extends ApiEvent {
  final Uuid uuid = Uuid();
  final String message;

  SendMessageEvent(this.message);

  @override
  List<Object?> get props => [uuid];
}

class SetPinsValue extends ApiEvent {
  final Uuid uuid = Uuid();
  @override
  List<Object?> get props => [uuid];
}
