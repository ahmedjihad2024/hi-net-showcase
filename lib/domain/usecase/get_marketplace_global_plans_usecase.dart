import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class GetMarketplaceGlobalPlansUseCase extends Base<NoParams, MarketplaceGlobalPlansResponse> {
  final RepositoryAbs _repository;

  GetMarketplaceGlobalPlansUseCase(this._repository);

  @override
  Future<Either<Failure, MarketplaceGlobalPlansResponse>> execute(NoParams input) async {
    return await _repository.getMarketplaceGlobalPlans();
  }
}
