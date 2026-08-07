import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/empty_list_state.dart';
import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
import 'package:dental_app/features/medical_archive/domain/medical_archive_helper.dart';
import 'package:dental_app/features/medical_archive/presentation/bloc/medical_archive_bloc.dart';
import 'package:dental_app/features/medical_archive/presentation/widgets/radiograph_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RadiographPage extends StatelessWidget {
  const RadiographPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MedicalArchiveBloc(),
      child: const _RadiographView(),
    );
  }
}

class _RadiographView extends StatefulWidget {
  const _RadiographView();

  @override
  State<_RadiographView> createState() => _RadiographViewState();
}

class _RadiographViewState extends State<_RadiographView> {
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final patientId = await SharedPrefs.getSelectedPatientId();
    if (!mounted) return;
    if (patientId == null || patientId.isEmpty) {
      setState(() => _items = []);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No patient selected'.tr())),
      );
      return;
    }
    // TEMP preview delay — remove later if not needed.
    await ShimmerPreview.wait();
    if (!mounted) return;
    context.read<MedicalArchiveBloc>().add(
          LoadMedicalArchiveRequested(
            patientId: patientId,
            type: MedicalArchiveHelper.typeXray,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: ColoredBox(
        color: scheme.surfaceContainerHighest,
        child: BlocConsumer<MedicalArchiveBloc, MedicalArchiveState>(
          listener: (context, state) {
            if (state is MedicalArchiveSuccess &&
                state.type == MedicalArchiveHelper.typeXray) {
              setState(() => _items = List.from(state.items));
            } else if (state is MedicalArchiveFailure &&
                state.type == MedicalArchiveHelper.typeXray) {
              setState(() => _items = []);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errMessage)),
              );
            }
          },
          buildWhen: (previous, current) =>
              current is MedicalArchiveLoading ||
              current is MedicalArchiveSuccess ||
              current is MedicalArchiveFailure ||
              current is MedicalArchiveInitial,
          builder: (context, state) {
            final loading = (state is MedicalArchiveLoading &&
                    state.type == MedicalArchiveHelper.typeXray) ||
                (state is MedicalArchiveInitial && _items.isEmpty);

            if (loading) {
              return const MedicalArchiveListShimmer(showThumbnail: true);
            }

            if (_items.isEmpty) {
              return EmptyListState(message: 'No radiographs'.tr());
            }

            return RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: RadiographCard(
                      imageUrl:
                          MedicalArchiveHelper.mediaPublicUrl(item) ?? '',
                      title: MedicalArchiveHelper.titleOf(item).isEmpty
                          ? 'Radiograph'.tr()
                          : MedicalArchiveHelper.titleOf(item),
                      planSessionLabel:
                          MedicalArchiveHelper.planSessionLabel(item),
                      date: MedicalArchiveHelper.formatDateOf(item),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
