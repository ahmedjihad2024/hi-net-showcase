import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/request/request.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class RefreshAuthTokenUseCase extends Base<RefreshTokenRequest, UserResponse> {
  final RepositoryAbs _repository;

  RefreshAuthTokenUseCase(this._repository);

  @override
  Future<Either<Failure, UserResponse>> execute(RefreshTokenRequest input) async {
    return await _repository.refreshAuth(input);
  }
}
