import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class GetLegalPoliciesUseCase extends Base<NoParams, LegalPoliciesResponse> {
  final RepositoryAbs _repository;

  GetLegalPoliciesUseCase(this._repository);

  @override
  Future<Either<Failure, LegalPoliciesResponse>> execute(NoParams input) async {
    return await _repository.getLegalPolicies();
  }
}
