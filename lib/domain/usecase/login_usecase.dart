import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/request/request.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class LoginUseCase extends Base<LoginRequest, RegisterResponse> {
  final RepositoryAbs _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, RegisterResponse>> execute(LoginRequest input) async {
    return await _repository.login(input);
  }
}
