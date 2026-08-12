import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum AppContentType {
  article,
  news,
  offer;

  static AppContentType fromApiValue(String? raw) {
    switch (raw?.toUpperCase()) {
      case 'NEWS':
        return AppContentType.news;
      case 'OFFER':
        return AppContentType.offer;
      case 'ARTICLE':
      default:
        return AppContentType.article;
    }
  }

  String get labelKey {
    switch (this) {
      case AppContentType.article:
        return 'Article';
      case AppContentType.news:
        return 'News';
      case AppContentType.offer:
        return 'Offer';
    }
  }

  String get label => labelKey.tr();

  IconData get icon {
    switch (this) {
      case AppContentType.article:
        return Icons.menu_book_rounded;
      case AppContentType.news:
        return Icons.newspaper_rounded;
      case AppContentType.offer:
        return Icons.local_offer_rounded;
    }
  }
}
