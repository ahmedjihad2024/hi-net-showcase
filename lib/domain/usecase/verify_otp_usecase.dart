import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/request/request.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class VerifyOtpUseCase extends Base<VerifyOtpRequest, UserResponse> {
  final RepositoryAbs _repository;

  VerifyOtpUseCase(this._repository);

  @override
  Future<Either<Failure, UserResponse>> execute(VerifyOtpRequest input) async {
    return await _repository.verifyOtp(input);
  }
}
