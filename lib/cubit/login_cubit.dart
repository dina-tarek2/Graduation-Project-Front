// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/cubit/login_state.dart';
import 'package:graduation_project_frontend/repositories/user_repository.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:graduation_project_frontend/widgets/custom_toast.dart'
    as custom_toast;

String? Id;

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.userRepository) : super(LoginInitial()) {}
  final UserRepository userRepository;
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoginPasswordShowing = true;
  IconData suffixIcon = Icons.visibility_off;
  String? currentUserId;
  bool isSocketListenersInitialized = false;

  IO.Socket socket =
      IO.io("https://graduation-project--xohomg.fly.dev/", <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": false,
  });

  void initSocket() {
    _setupSocketListeners();

    socket.connect();
  }

  void _setupSocketListeners() {
    if (isSocketListenersInitialized) return;

    isSocketListenersInitialized = true;
    socket.on("connect", (_) {
      print("Connected to WebSocket");
      if (currentUserId != null) {
        makeUserOnline(currentUserId!);
      }
    });
    socket.on("initialNotifications", (notifications) {
      for (int i = 0; i < notifications.length; i++) {
        if (i % 2 == 0) {
          notifications[i]['sound'] = "";
        }
        ;
        getNotify(notifications[i]);
        Duration(seconds: 5);
      }
    });

    socket.on("rich_notification", (notification) {
      print("Received rich notification: $notification");
      notification['sound'] = "";
      getNotify(notification);
    });

    socket.onAny((event, data) {
      print("📡 Event received: $event, Data: $data");
    });

    socket.on("connect_error", (error) {
      print("Socket connection error: $error");
      Future.delayed(Duration(seconds: 3), () {
        if (!socket.connected && currentUserId != null) {
          socket.connect();
        }
      });
    });
    socket.on("disconnect", (_) {
      print("Disconnected from WebSocket");
      makeUserOffline(currentUserId!);
    });
  }

  void connectToSocket(String userId) {
    currentUserId = userId;

    if (!socket.connected) {
      _setupSocketListeners();
      socket.connect();
    } else {
      makeUserOnline(userId);
    }
  }

  void logout(String userId) {
    if (socket.connected) {
      print(" Emitted userOffline for user $userId");
    }

    socket.disconnect();
  }

  void makeUserOnline(String userId) {
    if (socket.connected) {
      socket.emit('userOnline', {
        'userId': userId,
      });
      print("Emitted userOnline for user $userId");
    }
  }

  // Function to grt notify
  void getNotify(notification) {
    if (socket.connected) {
      final iconData = "https://i.pinimg.com/originals/54/72/d1/5472d1b09d3d724228109d381d617326.jpg";
      final bool isImageUrl = iconData != null && iconData.startsWith('http');
      custom_toast.showAdvancedNotification(
        custom_toast.AdvancedNotification.getContext(),
        message: notification['message'],
        title: notification['title'],
        image: isImageUrl ? iconData : null,
        icon: !isImageUrl
            ? Icon(Icons.notifications)
            : null, 
        sound: notification['sound'],
        date: DateTime.parse(notification['createdAt']),
        type: custom_toast.NotificationType.notify,
        duration: Duration(seconds: 5),
        style: custom_toast.AnimationStyle.notify,
      );
    }
  }

  void makeUserOffline(String userId) {
    if (socket.connected) {
      socket.emit('userOffline', {
        'userId': userId,
      });
      print("Emitted userOffline for user $userId");
    }
  }

  void changeLoginPasswordSuffixIcon() {
    isLoginPasswordShowing = !isLoginPasswordShowing;
    suffixIcon =
        isLoginPasswordShowing ? Icons.visibility : Icons.visibility_off;
    emit(ChangeLoginPasswordSuffixIcon());
  }

  Future<void> login() async {
    emit(LoginLoading());
    final response = await userRepository.login(
        email: emailController.text, password: passwordController.text);
    // String errorMessage = response['message'] ?? 'An unknown error occurred.';
    response.fold((errorMassage) {
      print("LoginError $errorMassage");

      emit(LoginError(errorMassage));
    }, (SignInModel) {
      emit(LoginSuccess(SignInModel.role));
      final userId = SignInModel.id;
      if (userId == null || userId.isEmpty) {
        print(userId);
        emit(LoginError("Invalid user ID received"));
        return;
      }
      currentUserId = userId;
      connectToSocket(userId);
    });
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    if (socket.connected && currentUserId != null) {
      socket.emit('userOffline', {
        'userId': currentUserId,
      });
    }
    socket.disconnect();
    socket.dispose();
    return super.close();
  }
}

class CenterCubit extends Cubit<String> {
  CenterCubit() : super('');

  void setCenterId(String id) {
    emit(id);
  }
}

class UserCubit extends Cubit<String> {
  UserCubit() : super('');

  void setUserRole(String role) {
    emit(role);
  }
}
