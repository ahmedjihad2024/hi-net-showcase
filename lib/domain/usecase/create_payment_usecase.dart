import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/request/request.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/base.dart';

class CreatePaymentUseCase
    extends Base<CreatePaymentRequest, CreatePaymentResponse> {
  final RepositoryAbs _repository;

  CreatePaymentUseCase(this._repository);

  @override
  Future<Either<Failure, CreatePaymentResponse>> execute(
    CreatePaymentRequest input,
  ) async {
    return await _repository.createPayment(input.channel.name, input);
  }
}
