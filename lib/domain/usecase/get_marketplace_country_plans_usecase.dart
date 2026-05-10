import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class GetMarketplaceCountryPlansUseCase extends Base<String, MarketplaceCountryPlansResponse> {
  final RepositoryAbs _repository;

  GetMarketplaceCountryPlansUseCase(this._repository);

  @override
  Future<Either<Failure, MarketplaceCountryPlansResponse>> execute(String input) async {
    return await _repository.getMarketplaceCountryPlans(input);
  }
}
