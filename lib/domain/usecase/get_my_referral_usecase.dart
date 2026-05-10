import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class GetMyReferralUseCase extends Base<NoParams, ReferralResponse> {
  final RepositoryAbs _repository;

  GetMyReferralUseCase(this._repository);

  @override
  Future<Either<Failure, ReferralResponse>> execute(NoParams input) async {
    return await _repository.getMyReferral();
  }
}
