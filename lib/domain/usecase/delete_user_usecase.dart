import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class DeleteUserUseCase extends Base<String, BasicResponse> {
  final RepositoryAbs _repository;

  DeleteUserUseCase(this._repository);

  @override
  Future<Either<Failure, BasicResponse>> execute(String input) async {
    return await _repository.deleteUser(input);
  }
}

