import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/request/request.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class UpdateUserInput {
  final String id;
  final UpdateUserRequest request;

  UpdateUserInput(this.id, this.request);
}

class UpdateUserUseCase extends Base<UpdateUserInput, GetUserResponse> {
  final RepositoryAbs _repository;

  UpdateUserUseCase(this._repository);

  @override
  Future<Either<Failure, GetUserResponse>> execute(UpdateUserInput input) async {
    return await _repository.updateUser(input.id, input.request);
  }
}

