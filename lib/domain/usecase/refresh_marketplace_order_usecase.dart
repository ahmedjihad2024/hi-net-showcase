import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class RefreshMarketplaceOrderUseCase extends Base<String, MarketplaceOrderResponse> {
  final RepositoryAbs _repository;

  RefreshMarketplaceOrderUseCase(this._repository);

  @override
  Future<Either<Failure, MarketplaceOrderResponse>> execute(String input) async {
    return await _repository.refreshMarketplaceOrder(input);
  }
}
