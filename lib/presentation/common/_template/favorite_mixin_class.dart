

// a common mixin to handle favorite toggling
import 'package:flutter_bloc/flutter_bloc.dart';

mixin FavoritesMixin<E, S> on Bloc<E, S> {
  Future<void> handleToggleFavorite({
    S Function()? loadingState,
    required int id,
    required bool isProvider,
    required Emitter<S> emit,
    S Function()? errorState,
    S Function()? successState,
  }) async {
    if (loadingState != null) {
      emit(loadingState());
    }
    
    // call api
    // if (isProvider) {
    //   Either<Failure, LikeProviderResponse> response =
    //       await instance<LikeProviderUseCase>()
    //           .execute(LikeProviderRequest(providerId: id));

    //   response.fold((failure) {
    //     if (errorState != null) {
    //       emit(errorState());
    //     }
    //   }, (data) {
    //     // update the event for the other screens
    //     if (data.data) {
    //       FavoritesManager.instance.addProviderToFavorites(id);
    //     } else {
    //       FavoritesManager.instance.removeProviderFromFavorites(id);
    //     }
    //   });
    // } else {
    //   // product favorite
    //   Either<Failure, LikeProviderResponse> response =
    //       await instance<LikeProductUseCase>()
    //           .execute(LikeProductRequest(productId: id));

    //   response.fold((failure) {
    //     if (errorState != null) {
    //       emit(errorState());
    //     }
    //   }, (data) {
    //     if (data.data) {
    //       FavoritesManager.instance.addProductToFavorites(id);
    //     } else {
    //       FavoritesManager.instance.removeProductFromFavorites(id);
    //     }
    //     if (successState != null) {
    //       emit(successState());
    //     }
    //   });
    // }
  }
}
