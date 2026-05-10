import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class GetMarketplaceCurrenciesUseCase
    extends Base<NoParams, MarketplaceCurrenciesResponse> {
  final RepositoryAbs _repository;

  GetMarketplaceCurrenciesUseCase(this._repository);

  @override
  Future<Either<Failure, MarketplaceCurrenciesResponse>> execute(
    NoParams input,
  ) async {
    return await _repository.getMarketplaceCurrencies();
  }
}
