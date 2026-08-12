import 'package:dental_app/core/widgets/empty_list_state.dart';
import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
import 'package:dental_app/features/promotional_gallery/data/models/app_content.dart';
import 'package:dental_app/features/promotional_gallery/presentation/bloc/promotional_gallery_bloc.dart';
import 'package:dental_app/features/promotional_gallery/presentation/widgets/gallery_post_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// تبويب "المعرض التسويقي" — FR-P-09، مربوط مع GET app/contents.
class PromotionalGalleryPage extends StatelessWidget {
  const PromotionalGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PromotionalGalleryBloc(),
      child: const _PromotionalGalleryView(),
    );
  }
}

class _PromotionalGalleryView extends StatefulWidget {
  const _PromotionalGalleryView();

  @override
  State<_PromotionalGalleryView> createState() => _PromotionalGalleryViewState();
}

class _PromotionalGalleryViewState extends State<_PromotionalGalleryView> {
  List<AppContent> _items = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    await ShimmerPreview.wait();
    if (!mounted) return;
    context.read<PromotionalGalleryBloc>().add(LoadAppContentsRequested());
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Promotional Gallery'.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.primary,
          ),
        ),
      ),
      backgroundColor: colors.surfaceContainerHighest,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/backgrounds/background1.png',
                fit: BoxFit.cover,
                color: colors.primary,
              ),
            ),
            SafeArea(
              child: BlocConsumer<PromotionalGalleryBloc, PromotionalGalleryState>(
                listener: (context, state) {
                  if (state is AppContentsSuccess) {
                    setState(() => _items = List.from(state.items));
                  } else if (state is AppContentsFailure) {
                    setState(() => _items = []);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errMessage)),
                    );
                  }
                },
                buildWhen: (previous, current) =>
                    current is AppContentsLoading ||
                    current is AppContentsSuccess ||
                    current is AppContentsFailure ||
                    current is PromotionalGalleryInitial,
                builder: (context, state) {
                  final loading = state is AppContentsLoading ||
                      (state is PromotionalGalleryInitial && _items.isEmpty);

                  if (loading) {
                    return const GalleryPostsListShimmer();
                  }

                  if (_items.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _load,
                      color: colors.primary,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.55,
                            child: EmptyListState(
                              message: 'No promotional content yet'.tr(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _load,
                    color: colors.primary,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) => FadeSlideIn(
                        delay: Duration(milliseconds: 40 * index),
                        child: GalleryPostCard(content: _items[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
