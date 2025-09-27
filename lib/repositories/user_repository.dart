import 'package:radintel/api_services/api_consumer.dart';
import 'package:radintel/api_services/end_points.dart';
import 'package:radintel/cubit/login_cubit.dart';
import 'package:radintel/models/signIn_model.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final ApiConsumer api;
  final CenterCubit centerCubit;
  final UserCubit userCubit;
  UserRepository({
    required this.api,
    required this.centerCubit,
    required this.userCubit,
  });

  Future<Either<String, SignInModel>> login(
      {required String email, required String password}) async {
    try {
      final response = await api.post(
        EndPoints.SignIn,
        data: {
          ApiKey.email: email,
          ApiKey.password: password,
        },
      );
      
      // Check if response is successful
      if (response.statusCode == 200) {
        final user = SignInModel.fromJson(response.data);
        String role = response.data["role"];
        userCubit.setUserRole(role);
        
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("userRole", role);
        
        if (response.data["role"] == "RadiologyCenter") {
          String centerId = response.data["user"]["id"];
          centerCubit.setCenterId(centerId);
        } else {
          String centerId = response.data["user"]["_id"];
          centerCubit.setCenterId(centerId);
        }
        return Right(user);
      } else {
        // Handle non-200 status codes
        print("=== USER REPOSITORY ERROR DEBUG ===");
        print("Status Code: ${response.statusCode}");
        print("Response Data: ${response.data}");
        print("Response Headers: ${response.headers}");
        
        String errorMessage;
        
        // Check for the specific rate limiting error format
        if (response.data != null && response.data['error'] != null) {
          print("=== RATE LIMITING ERROR DETECTED IN REPOSITORY ===");
          print("Error field: ${response.data['error']}");
          print("RetryAfter field: ${response.data['retryAfter']}");
          
          errorMessage = response.data['error'];
          
          // If it's a rate limiting error, add retry information
          if (response.data['retryAfter'] != null) {
            int retryAfter = response.data['retryAfter'];
            int minutes = (retryAfter / 60).round();
            errorMessage += " Please try again in $minutes minutes.";
            print("Added retry information: $minutes minutes");
          }
        } else {
          errorMessage = response.data?['message'] ?? 'Login failed. Please try again.';
        }
        
        print("Final error message: $errorMessage");
        return Left(errorMessage);
      }
    } catch (e) {
      // Handle network errors and other exceptions
      String errorMessage;
      if (e.toString().contains('SocketException') || e.toString().contains('TimeoutException')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (e.toString().contains('FormatException')) {
        errorMessage = 'Invalid response from server. Please try again.';
      } else {
        errorMessage = 'Login failed. Please check your credentials and try again.';
      }
      return Left(errorMessage);
    }
  }
}
