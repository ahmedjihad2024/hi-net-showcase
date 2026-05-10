import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/request/request.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class CountrySearchUseCase
    extends Base<CountrySearchRequest, CountrySearchResponse> {
  final RepositoryAbs _repository;

  CountrySearchUseCase(this._repository);

  @override
  Future<Either<Failure, CountrySearchResponse>> execute(
    CountrySearchRequest input,
  ) async {
    return await _repository.getCountrySearch(input);
  }
}
