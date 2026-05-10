import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/request/request.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class GetMarketplaceSearchUseCase extends Base<MarketplaceSearchRequest, MarketplaceSearchResponse> {
  final RepositoryAbs _repository;

  GetMarketplaceSearchUseCase(this._repository);

  @override
  Future<Either<Failure, MarketplaceSearchResponse>> execute(MarketplaceSearchRequest input) async {
    return await _repository.getMarketplaceSearch(input);
  }
}
