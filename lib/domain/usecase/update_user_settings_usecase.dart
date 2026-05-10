import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/request/request.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class UpdateUserSettingsUseCase
    extends Base<UpdateUserSettingsRequest, GetUserResponse> {
  final RepositoryAbs _repository;

  UpdateUserSettingsUseCase(this._repository);

  @override
  Future<Either<Failure, GetUserResponse>> execute(
    UpdateUserSettingsRequest input,
  ) async {
    return await _repository.updateUserSettings(input);
  }
}

