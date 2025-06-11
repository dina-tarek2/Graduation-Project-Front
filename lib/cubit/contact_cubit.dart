import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit(
    this.api,
  ) : super(ContactInitial());
  final ApiConsumer api;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  Future<void> contact() async {
    try {
      emit(ContactLoading());
      await api.post(
        EndPoints.SentEmail,
        data: {
          ApiKey.name: nameController.text,
          ApiKey.email: emailController.text,
          ApiKey.phone: phoneController.text,
          ApiKey.massage: messageController.text,
        },
      );
      // final message = response.data['message'] ?? "Message sent successfully";
      emit(ContactSuccess());
    } catch (e) {
      emit(ContactFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    phoneController.dispose();
    nameController.dispose();
    messageController.dispose();
    return super.close();
  }
}
