import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class GetOrderInput {
  final String orderId;
  final String? currency;

  GetOrderInput(this.orderId, {this.currency});
}

class GetMarketplaceOrderUseCase extends Base<GetOrderInput, MarketplaceOrderResponse> {
  final RepositoryAbs _repository;

  GetMarketplaceOrderUseCase(this._repository);

  @override
  Future<Either<Failure, MarketplaceOrderResponse>> execute(GetOrderInput input) async {
    return await _repository.getMarketplaceOrder(input.orderId, currency: input.currency);
  }
}
