import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class GetWalletBalanceUseCase extends Base<NoParams, WalletBalanceResponse> {
  final RepositoryAbs _repository;

  GetWalletBalanceUseCase(this._repository);

  @override
  Future<Either<Failure, WalletBalanceResponse>> execute(NoParams input) async {
    return await _repository.getWalletBalance();
  }
}
