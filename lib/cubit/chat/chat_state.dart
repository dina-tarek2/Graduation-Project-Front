part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<dynamic> messages;
  
  const ChatLoaded({required this.messages});
  
  @override
  List<Object> get props => [messages];
}

class ChatError extends ChatState {
  final String error;
  
  const ChatError({required this.error});
  
  @override
  List<Object> get props => [error];
}

class NewMessageReceived extends ChatState {
  final dynamic message;
  
  const NewMessageReceived({required this.message});
  
  @override
  List<Object> get props => [message];
}
class ConversationsLoaded extends ChatState{
   final List<dynamic> conversations;
  
  const ConversationsLoaded({required this.conversations});
  
}
// New connection-related states
class SocketConnected extends ChatState {}

class SocketDisconnected extends ChatState {}

class PartnerOnline extends ChatState {}

class PartnerOffline extends ChatState {}
class ChatPartnerSelected extends ChatState {}
class ChatClosedState extends ChatState {} 