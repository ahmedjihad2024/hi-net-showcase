import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class GetSettingsUseCase implements Base<void, SettingsResponse> {
  final RepositoryAbs _repository;

  GetSettingsUseCase(this._repository);

  @override
  Future<Either<Failure, SettingsResponse>> execute(void input) async {
    return await _repository.getSettings();
  }
}
