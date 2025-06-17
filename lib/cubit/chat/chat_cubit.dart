import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
   ApiConsumer api ;
  final String userId;
  final String userType;
  late String partnerId;
  late String partnerType;
  late IO.Socket socket;
  bool isOnline = false;
 List<dynamic> conversations = [];
  ChatCubit({
    required this.api,
    required this.userId,
    required this.userType,
    // required this.partnerId,
    // required this.partnerType,
  }) : super(ChatInitial()) {
  }
  
  void setPartner({required String newPartnerId,required String newPartnerType}) {
    partnerId = newPartnerId;
    partnerType = newPartnerType;
    emit(ChatPartnerSelected()); 
    fetchMessages(receiverId: newPartnerId, receiverType: newPartnerType);
  }
//   void _connectToSocket() {
//     socket = IO.io("https://graduation-project--xohomg.fly.dev", <String, dynamic>{
//       "transports": ["websocket"],
//       "autoConnect": false,
//     });
 
//     socket.connect();

//        socket.on("connect", (_) {
//       print("Connected to WebSocket");
//       isOnline = true;
//       _emitUserOnline();
//       emit(SocketConnected());
//     });


//     socket.on("disconnect", (_) {
//       print("Disconnected from WebSocket");
//       isOnline = false;
//       _emitUserOffline();
//       emit(SocketDisconnected());
//     });
//     socket.on("message", (data) {
//       print("New message: $data");
//       emit(NewMessageReceived(message: data));
//     });
//     socket.on('newMessage', (data) {
//       emit(NewMessageReceived(message: data));
//   });
//   }
//   void _emitUserOnline() {
//     socket.emit('userOnline', {
//       'userId': userId,
//       'userType': userType,
//     });
//   }
// void _emitUserOffline() {
//     socket.emit('userOffline', {
//       'userId': userId,
//     });
//   }

 
Future<void> fetchConversations() async {
    emit(ChatLoading());
    try {
      final response = await api.get(
        "https://graduation-project-mmih.vercel.app/api/messages/RadiologistListChat",
        queryParameters: {
          "userId": userId,
          "userType": userType,
        },
      );

      if (response.data['success'] == true) {
        emit(ConversationsLoaded(conversations: response.data['radiologists']));
      } else {
        emit(ChatError(error: "Failed to load conversations"));
      }
    } catch (e) {
      emit(ChatError(error: "Error fetching conversations: ${e.toString()}"));
    }
  }
 
 
Future<void> fetchConversationsForDoctor() async {
    emit(ChatLoading());
    try {
      final response = await api.get(
        'https://graduation-project-mmih.vercel.app/api/messages/CenterListChat',
        queryParameters: {
          "userId": userId,
          "userType": userType,
        },
      );

      if (response.data['success'] == true) {
        emit(ConversationsLoaded(conversations: response.data['centers']));
      } else {
        emit(ChatError(error: "Failed to load conversations"));
      }
    } catch (e) {
      emit(ChatError(error: "Error fetching conversations: ${e.toString()}"));
    }
  }

  Future<void> fetchMessages({required receiverId, required String receiverType}) async {
    emit(ChatLoading());
    try {
      final response = await api.get(
        "https://graduation-project--xohomg.fly.dev/api/messages/conversation",
        queryParameters: {
          "userId": userId,
          "userType": userType,
          "partnerId": partnerId,
          "partnerType": partnerType
        },
      );

      if (response.data['success'] == true && response.data['data'] is List) {
      // Use the 'data' array directly
      emit(ChatLoaded(messages: response.data['data']));
    } else {
      emit(ChatError(error: "Failed to load messages"));
      }
    } catch (e) {
      emit(ChatError(error: "An error occurred: ${e.toString()}"));
    }
  }
  Future<void> sendMessage(String content) async {
      if (partnerId.isEmpty || partnerType.isEmpty) {
    print("Error: Cannot send message without a selected partner!");
    return;
  }
    try {
      
    //   socket.emit('sendMessage', {
    //     "senderId": userId,
    //       "senderType": userType,
    //       "receiverId": partnerId,
    //       "receiverType": partnerType,
    //       "content": content,
    //   });

      final response = await api.post(
        "https://graduation-project--xohomg.fly.dev/api/messages/send",
        data: {
          "senderId": userId,
          "senderType": userType,
          "receiverId": partnerId,
          "receiverType": partnerType,
          "content": content,
        },
      );

      if (response.statusCode == 201) {
        await fetchMessages(receiverId: partnerId,receiverType: partnerType); 
      } else {
        print("Failed to send message: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending message: ${e.toString()}");
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}

