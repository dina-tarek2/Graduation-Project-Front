import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';
import 'package:graduation_project_frontend/models/Admin/approved_centers_model.dart';

part 'manage_centers_state.dart';

class ManageCentersCubit extends Cubit<ManageCentersState> {
  ManageCentersCubit(this.api) : super(ManageCentersInitial());

  final ApiConsumer api;
  final TextEditingController centerNameController = TextEditingController();
  final TextEditingController contactNoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();

  final TextEditingController cityController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  Future<void> fetchApprovedCenters() async {
    try {
      emit(ManageCentersLoading());
      final response = await api.get(EndPoints.getApprovedCenters);

      final approvedcenterModel = ApprovedCentersModel.fromJson(response.data);

      if (response.statusCode == 200) {
        emit(ManageCentersSuccess(centers: approvedcenterModel.data));
      }
    } on DioException catch (e) {
      print("DioException Error: ${e.message}");
      print("DioException Response: ${e.response?.data}");
      print("DioException Status Code: ${e.response?.statusCode}");

      emit(ManageCentersFailure(error: e.message ?? "Unknown Dio Error"));
    } catch (e) {
      print("Unknown Error: $e");
      emit(ManageCentersFailure(error: "$e"));
    }
  }

  Future<void> AddCenter() async {
    try {
      final response = await api.post(EndPoints.addCenterByAdmin, data: {
        "centerName": centerNameController.text,
        "street": streetController.text,
        "city": cityController.text,
        "state": stateController.text,
        "zipCode": zipCodeController.text,
        "contactNumber": contactNoController.text,
        "email": emailController.text,
        "password": passwordController.text
        //   "image" //   "path"
      });

      if (response.statusCode == 201) {
        emit(AddCenterSuccess());
        fetchApprovedCenters();
      } else {}
    } catch (error) {
      if (error is DioException) {
        print("DioException Error: ${error.message}");
        print("DioException Response: ${error.response?.data}");
        print("DioException Status Code: ${error.response?.statusCode}");
      } else {
        print("Unknown Error: $error");
      }
      emit(AddCenterFailure(error: "$error"));
    }
  }

  @override
  Future<void> close() {
    centerNameController.dispose();
    contactNoController.dispose();
    emailController.dispose();
    passwordController.dispose();

    zipCodeController.dispose();
    cityController.dispose();
    streetController.dispose();
    stateController.dispose();
    return super.close();
  }
}
