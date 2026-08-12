part of 'promotional_gallery_bloc.dart';

@immutable
sealed class PromotionalGalleryState {}

final class PromotionalGalleryInitial extends PromotionalGalleryState {}

final class AppContentsLoading extends PromotionalGalleryState {}

final class AppContentsSuccess extends PromotionalGalleryState {
  final List<AppContent> items;
  final int total;

  AppContentsSuccess({
    required this.items,
    required this.total,
  });
}

final class AppContentsFailure extends PromotionalGalleryState {
  final String errMessage;

  AppContentsFailure({required this.errMessage});
}
