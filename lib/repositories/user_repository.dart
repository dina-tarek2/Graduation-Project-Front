import 'package:dio/dio.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/models/signIn_model.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
class UserRepository {
  final ApiConsumer api ;
final CenterCubit centerCubit;
final UserCubit userCubit;
  UserRepository({required this.api,
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
      final user = SignInModel.fromJson(response.data);
      final decodedToken = JwtDecoder.decode(user.token);
      String Id = decodedToken['id'];
      String role = response.data["role"];
      userCubit.setUserRole(role);
       SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("userRole", role);
 if (response.statusCode== 200){
   if (response.data["role"] == "Radiologist") {
          String centerId = response.data["user"]["_id"];
          centerCubit.setCenterId(centerId);
        }else{
          String centerId = response.data["user"]["id"];
          centerCubit.setCenterId(centerId);
        }
        return Right(user);
} else {
        return Left(response.data['message']);
      }
  } catch (e) {
return Left(e.toString());
  }
  }
}

