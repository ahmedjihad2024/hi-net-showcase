import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/request/request.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class GetMyOrdersUseCase extends Base<MyOrdersParams, MyOrdersResponse> {
  final RepositoryAbs _repository;

  GetMyOrdersUseCase(this._repository);

  @override
  Future<Either<Failure, MyOrdersResponse>> execute(
    MyOrdersParams input,
  ) async {
    return await _repository.getMyOrders(input);
  }
}
