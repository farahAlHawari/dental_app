part of 'promotional_gallery_bloc.dart';

@immutable
sealed class PromotionalGalleryEvent {}

final class LoadAppContentsRequested extends PromotionalGalleryEvent {
  final int page;
  final int pageSize;

  LoadAppContentsRequested({
    this.page = 1,
    this.pageSize = 50,
  });
}
