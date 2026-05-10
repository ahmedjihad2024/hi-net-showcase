import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/request/request.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class CreateOrderUseCase extends Base<CreateOrderRequest, MarketplaceOrderResponse> {
  final RepositoryAbs _repository;

  CreateOrderUseCase(this._repository);

  @override
  Future<Either<Failure, MarketplaceOrderResponse>> execute(CreateOrderRequest input) async {
    return await _repository.createOrder(input);
  }
}
