import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/request/request.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class GetOrderHistoryUseCase
    extends Base<OrderHistoryParams, OrderHistoryResponse> {
  final RepositoryAbs _repository;

  GetOrderHistoryUseCase(this._repository);

  @override
  Future<Either<Failure, OrderHistoryResponse>> execute(
    OrderHistoryParams input,
  ) async {
    return await _repository.getOrderHistory(input);
  }
}
