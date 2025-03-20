import '../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote_data_source.dart';
import '../models/login_request.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login(String email, String password) async {
    try {
      final loginRequest = LoginRequest(email: email, password: password);
      final loginResponse = await remoteDataSource.login(loginRequest);
      if(loginResponse != null && loginResponse.userId != null) {
        final userModel = UserModel(email);
        return userModel;
      } else {
        throw ServerFailure("Login Failed");
      }
    } on ServerFailure catch (e) {

      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('An unknown error occurred.');
    }
  }
}