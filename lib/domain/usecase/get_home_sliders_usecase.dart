import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class GetHomeSlidersUseCase extends Base<NoParams, HomeSlidersResponse> {
  final RepositoryAbs _repository;

  GetHomeSlidersUseCase(this._repository);

  @override
  Future<Either<Failure, HomeSlidersResponse>> execute(NoParams input) async {
    return await _repository.getHomeSliders();
  }
}
