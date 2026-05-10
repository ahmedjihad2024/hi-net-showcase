import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class GetFeaturedCountriesUseCase
    extends Base<void, FeaturedCountriesResponse> {
  final RepositoryAbs _repository;

  GetFeaturedCountriesUseCase(this._repository);

  @override
  Future<Either<Failure, FeaturedCountriesResponse>> execute(void _) async {
    return await _repository.getFeaturedCountries();
  }
}
