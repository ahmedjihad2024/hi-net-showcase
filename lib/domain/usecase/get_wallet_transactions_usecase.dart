import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/request/request.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class GetWalletTransactionsUseCase
    extends Base<WalletTransactionsParams, WalletTransactionsResponse> {
  final RepositoryAbs _repository;

  GetWalletTransactionsUseCase(this._repository);

  @override
  Future<Either<Failure, WalletTransactionsResponse>> execute(
    WalletTransactionsParams input,
  ) async {
    return await _repository.getWalletTransactions(input);
  }
}
