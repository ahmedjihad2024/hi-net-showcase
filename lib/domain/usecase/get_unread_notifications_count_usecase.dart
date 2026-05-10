import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class GetUnreadNotificationsCountUseCase
    extends Base<NoParams, UnreadNotificationCountResponse> {
  final RepositoryAbs _repository;

  GetUnreadNotificationsCountUseCase(this._repository);

  @override
  Future<Either<Failure, UnreadNotificationCountResponse>> execute(
    NoParams input,
  ) async {
    return await _repository.getUnreadNotificationsCount();
  }
}
