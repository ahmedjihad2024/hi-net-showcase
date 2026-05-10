// import 'package:bloc_test/bloc_test.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hi_net/app/dependency_injection.dart' as GetIt;
// import 'package:hi_net/app/enums.dart';
// import 'package:hi_net/app/services/app_preferences.dart';
// import 'package:hi_net/data/network/api.dart';
// import 'package:hi_net/data/network/error_handler/error_handler.dart';
// import 'package:hi_net/data/network/error_handler/failure.dart';
// import 'package:hi_net/data/repository/repository_impl.dart';
// import 'package:hi_net/data/request/request.dart';
// import 'package:hi_net/data/responses/responses.dart';
// import 'package:hi_net/domain/usecase/login_usecase.dart';
// import 'package:hi_net/presentation/common/utils/ui_feedback.dart';
// import 'package:hi_net/presentation/views/sign_in/bloc/sign_in_bloc.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// /// flutter pub run build_runner clean
// /// flutter pub get
// /// flutter pub run build_runner build

// @GenerateNiceMocks([MockSpec<AppServices>(), MockSpec<LoginUseCase>()])
// import 'auth_test.mocks.dart';

// final fakeUserSuccessResponse = UserResponse(
//   success: true,
//   message: 'Login successful',
//   errorType: '',
//   accessToken: 'accessToken',
//   refreshToken: 'refreshToken',
//   user: User(
//     id: 'user_12345',
//     status: 'active',
//     createdAt: '2023-01-15T10:00:00Z',
//     modifiedAt: '2023-12-20T14:30:00Z',
//     fullName: 'John Doe',
//     mobile: '01095651645',
//     callingCode: '+20',
//     roleId: 'role_customer',
//     settings: UserSettingsResponse(
//       language: 'en',
//       theme: 'dark',
//       currency: Currency.USD,
//     ),
//     firebaseTokens: ['token_1', 'token_2'],
//   ),
// );

// final fakeUserErrorResponse = UserResponse(
//   success: false,
//   message: 'Invalid credentials',
//   errorType: 'UnauthorizedException',
// );

// final fakeRegisterSuccessResponse = RegisterResponse(
//   success: true,
//   message: 'OTP sent',
//   errorType: null,
//   status: 'PENDING',
//   expiresInMinutes: 5,
//   mobile: '01095651645',
//   callingCode: '+20',
// );

// final fakeRegisterErrorResponse = RegisterResponse(
//   success: false,
//   message: 'User already exists',
//   errorType: 'BadRequestException',
// );

// final fakeBasicSuccessResponse = BasicResponse(
//   success: true,
//   message: 'Logout successful',
//   errorType: null,
// );

// final fakeBasicErrorResponse = BasicResponse(
//   success: false,
//   message: 'Unauthorized',
//   errorType: 'UnauthorizedException',
// );

// // bloc testes requirements
// class MockUiFeedback extends Mock implements UiFeedback {}

// void main() {
//   group('Auth Repository', () {
//     late MockAppServices mockAppServices;
//     late Repository repository;

//     setUp(() async {
//       mockAppServices = MockAppServices();

//       repository = Repository(mockAppServices);
//     });

//     test('login should call AppServices.login Success State', () async {
//       // Arrange
//       final loginRequest = LoginRequest(
//         mobile: "01095651645",
//         callingCode: "+20",
//         password: "password",
//       );

//       when(
//         mockAppServices.login(loginRequest),
//       ).thenAnswer((_) async => fakeUserSuccessResponse);

//       // Act
//       final result = await repository.login(loginRequest);

//       // Assert
//       expect(result.isRight(), isTrue);
//       result.fold((error) {}, (data) {
//         expect(data.user!.fullName, "John Doe");
//       });
//     });

//     test('login should call AppServices.login Internet Error State', () async {
      
//       // Arrange
//       final loginRequest = LoginRequest(
//         mobile: "01095651645",
//         callingCode: "+20",
//         password: "password",
//       );

//       // Act
//       final result = await repository.login(loginRequest);

//       // Assert
//       expect(result.isLeft(), isTrue);
//       result.fold((error) {
//         expect(error, isInstanceOf<NoInternetConnection>());
//       }, (data) {});
//     });

//     test('login should call AppServices.login Server Error State', () async {
      
//       // Arrange
//       final loginRequest = LoginRequest(
//         mobile: "01095651645",
//         callingCode: "+20",
//         password: "password",
//       );

//       when(
//         mockAppServices.login(loginRequest),
//       ).thenAnswer((_) async => fakeUserErrorResponse);

//       // Act
//       final result = await repository.login(loginRequest);

//       // Assert
//       expect(result.isLeft(), isTrue);
//       result.fold((error) {
//         expect(error, isInstanceOf<ServerError>());
//         expect((error as ServerError).message, "Invalid credentials");
//       }, (data) {});
//     });

//     test('register should return NoInternetConnection', () async {
      

//       final request = RegisterRequest(
//         fullName: "Ahmed",
//         mobile: '01095651645',
//         callingCode: '+20',
//         password: 'password',
//       );

//       final result = await repository.register(request);

//       expect(result.isLeft(), isTrue);

//       result.fold(
//         (error) => expect(error, isInstanceOf<NoInternetConnection>()),
//         (_) {},
//       );
//     });

//     test('register should return Success State', () async {
      

//       final request = RegisterRequest(
//         fullName: "Ahmed",
//         mobile: '01095651645',
//         callingCode: '+20',
//         password: 'password',
//       );

//       when(
//         mockAppServices.register(request),
//       ).thenAnswer((_) async => fakeRegisterSuccessResponse);

//       final result = await repository.register(request);

//       expect(result.isRight(), isTrue);

//       result.fold((_) {}, (data) {
//         expect(data.status, 'PENDING');
//         expect(data.expiresInMinutes, 5);
//       });
//     });

//     test('register should return ServerError', () async {
      

//       final request = RegisterRequest(
//         fullName: "Ahmed",
//         mobile: '01095651645',
//         callingCode: '+20',
//         password: 'password',
//       );

//       when(
//         mockAppServices.register(request),
//       ).thenAnswer((_) async => fakeRegisterErrorResponse);

//       final result = await repository.register(request);

//       expect(result.isLeft(), isTrue);

//       result.fold((error) {
//         expect(error, isInstanceOf<ServerError>());
//         expect((error as ServerError).message, 'User already exists');
//       }, (_) {});
//     });

//     test('verifyOtp should return Success State', () async {
      

//       final request = VerifyOtpRequest(
//         mobile: '01095651645',
//         callingCode: '+20',
//         otp: '123456',
//       );

//       when(
//         mockAppServices.verifyOtp(request),
//       ).thenAnswer((_) async => fakeUserSuccessResponse);

//       final result = await repository.verifyOtp(request);

//       expect(result.isRight(), isTrue);

//       result.fold((_) {}, (data) => expect(data.accessToken, isNotNull));
//     });

//     test('verifyOtp should return NoInternetConnection', () async {
      

//       final request = VerifyOtpRequest(
//         mobile: '01095651645',
//         callingCode: '+20',
//         otp: '123456',
//       );

//       final result = await repository.verifyOtp(request);

//       expect(result.isLeft(), isTrue);

//       result.fold(
//         (error) => expect(error, isInstanceOf<NoInternetConnection>()),
//         (_) {},
//       );
//     });

//     test('verifyOtp should return ServerError', () async {
      

//       final request = VerifyOtpRequest(
//         mobile: '01095651645',
//         callingCode: '+20',
//         otp: '123456',
//       );

//       when(
//         mockAppServices.verifyOtp(request),
//       ).thenAnswer((_) async => fakeUserErrorResponse);

//       final result = await repository.verifyOtp(request);

//       expect(result.isLeft(), isTrue);

//       result.fold((error) {
//         expect(error, isInstanceOf<ServerError>());
//         expect((error as ServerError).message, 'Invalid credentials');
//       }, (_) {});
//     });

//     test('logout should return Success State', () async {
      

//       final request = LogoutRequest(refreshToken: "dead");

//       when(
//         mockAppServices.logout(request),
//       ).thenAnswer((_) async => fakeBasicSuccessResponse);

//       final result = await repository.logout(request);

//       expect(result.isRight(), isTrue);

//       result.fold((_) {}, (data) => expect(data.message, 'Logout successful'));
//     });

//     test('logout should return NoInternetConnection', () async {
      

//       final request = LogoutRequest(refreshToken: "dead");

//       final result = await repository.logout(request);

//       expect(result.isLeft(), isTrue);

//       result.fold(
//         (error) => expect(error, isInstanceOf<NoInternetConnection>()),
//         (_) {},
//       );
//     });

//     test('logout should return ServerError', () async {
      

//       final request = LogoutRequest(refreshToken: "dead");

//       when(
//         mockAppServices.logout(request),
//       ).thenAnswer((_) async => fakeBasicErrorResponse);

//       final result = await repository.logout(request);

//       expect(result.isLeft(), isTrue);

//       result.fold((error) {
//         expect(error, isInstanceOf<ServerError>());
//         expect((error as ServerError).message, 'Unauthorized');
//       }, (_) {});
//     });
//   });

//   group("Auth Blocs", () {
//     WidgetsFlutterBinding.ensureInitialized();
//     var instance = GetIt.instance;
//     late MockLoginUseCase mockLoginUseCase;
//     setUp(() async {
//       await instance.reset();
//       mockLoginUseCase = MockLoginUseCase();
//       SharedPreferences.setMockInitialValues({});
//       var pref = await SharedPreferences.getInstance();
//       instance.registerLazySingleton<AppPreferences>(
//         () => AppPreferences(pref),
//       );
//       instance.registerFactory<LoginUseCase>(() => mockLoginUseCase);
//     });

//     blocTest(
//       'Success Login State',
//       build: () {
//         when(
//           mockLoginUseCase.execute(any),
//         ).thenAnswer((_) async => Right(fakeUserSuccessResponse));
//         return SignInBloc(instance, MockUiFeedback());
//       },
//       act: (bloc) =>
//           bloc.add(SubmitSignInEvent(phone: "01095651645", dialCode: "+20")),
//       expect: () => [isInstanceOf<SuccessSignInState>()],
//       verify: (_) {
//         // ✅ Here you check the saved tokens
//         final prefs = instance<AppPreferences>();
//         expect(prefs.token, fakeUserSuccessResponse.accessToken);
//         expect(prefs.refreshToken, fakeUserSuccessResponse.refreshToken);
//       },
//     );

//     blocTest(
//       'Failure Login State',
//       build: () {
//         when(mockLoginUseCase.execute(any)).thenAnswer(
//           (_) async => Left(
//             CustomServerError(error: ApiErrorType.UNAUTHORIZED_EXCEPTION),
//           ),
//         );
//         return SignInBloc(instance, MockUiFeedback());
//       },
//       act: (bloc) =>
//           bloc.add(SubmitSignInEvent(phone: "01095651645", dialCode: "+20")),
//       expect: () => [isInstanceOf<NeedSignUpState>()],
//     );
//   });
// }
