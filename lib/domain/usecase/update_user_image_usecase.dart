import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/request/request.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class UpdateUserImageUseCase
    extends Base<UpdateUserImageRequest, GetUserResponse> {
  final RepositoryAbs _repository;

  UpdateUserImageUseCase(this._repository);

  @override
  Future<Either<Failure, GetUserResponse>> execute(
    UpdateUserImageRequest input,
  ) async {
    return await _repository.updateUserImage(input);
  }
}
