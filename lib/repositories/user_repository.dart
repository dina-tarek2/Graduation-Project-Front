import 'package:dio/dio.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';
import 'package:graduation_project_frontend/models/signIn_model.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:dartz/dartz.dart';
late String centerIdd;
class UserRepository {
  final ApiConsumer api ;

  UserRepository({required this.api});

Future<Either<String,SignInModel>> login({
         required String email,
         required String password}) async {
    try {
      final response = await api.post(
        EndPoints.SignIn,
        data: {
          ApiKey.email: email,
          ApiKey.password: password,
        },
      );
      final user = SignInModel.fromJson(response);
      final decodedToken = JwtDecoder.decode(user.token);
      String Id = decodedToken['id'];
if (response is Map && response.containsKey("user")) {
  centerIdd = response["user"]["_id"];
} else {
  print("Unexpected response structure: $response");
}
           
      return Right(user);
    } on DioException catch (e) {
      if (e.response?.data is Map) {
        final errorMessage = e.response?.data['message'] ?? 'Unknown error';
        return Left(errorMessage);
      }
      
      return Left(e.response?.data.toString() ?? 'An error occurred');
    }
  }
  }