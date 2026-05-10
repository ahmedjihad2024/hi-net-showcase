import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/request/request.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class GetNotificationsUseCase
    extends Base<NotificationParams, NotificationListResponse> {
  final RepositoryAbs _repository;

  GetNotificationsUseCase(this._repository);

  @override
  Future<Either<Failure, NotificationListResponse>> execute(
    NotificationParams input,
  ) async {
    return await _repository.getNotifications(input);
  }
}
