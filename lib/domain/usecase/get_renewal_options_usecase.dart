import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class GetRenewalOptionsUseCase extends Base<String, RenewalOptionsResponse> {
  final RepositoryAbs _repository;

  GetRenewalOptionsUseCase(this._repository);

  @override
  Future<Either<Failure, RenewalOptionsResponse>> execute(String input) async {
    return await _repository.getRenewalOptions(input);
  }
}
