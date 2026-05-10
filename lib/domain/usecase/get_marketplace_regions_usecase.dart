import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class GetMarketplaceRegionsUseCase extends Base<NoParams, MarketplaceRegionsResponse> {
  final RepositoryAbs _repository;

  GetMarketplaceRegionsUseCase(this._repository);

  @override
  Future<Either<Failure, MarketplaceRegionsResponse>> execute(NoParams input) async {
    return await _repository.getMarketplaceRegions();
  }
}
