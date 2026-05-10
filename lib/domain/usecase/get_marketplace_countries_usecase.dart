import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class GetMarketplaceCountriesUseCase extends Base<NoParams, MarketplaceCountriesResponse> {
  final RepositoryAbs _repository;

  GetMarketplaceCountriesUseCase(this._repository);

  @override
  Future<Either<Failure, MarketplaceCountriesResponse>> execute(NoParams input) async {
    return await _repository.getMarketplaceCountries();
  }
}
