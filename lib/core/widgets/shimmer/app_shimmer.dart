import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shared shimmer colors from the current theme.
class AppShimmer extends StatelessWidget {
  final Widget child;

  const AppShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark
          ? scheme.surfaceContainerHighest
          : Colors.grey.shade300,
      highlightColor: isDark
          ? scheme.surfaceContainerHigh
          : Colors.grey.shade100,
      child: child,
    );
  }
}

/// Short preview delay so shimmer is visible before fast API responses.
class ShimmerPreview {
  static const Duration delay = Duration(milliseconds: 1200);

  static Future<void> wait() => Future<void>.delayed(delay);
}

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }
}

/// Skeleton matching radiograph / report archive cards.
class MedicalArchiveCardShimmer extends StatelessWidget {
  final bool showThumbnail;

  const MedicalArchiveCardShimmer({
    super.key,
    this.showThumbnail = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: AppShimmer(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showThumbnail)
                const ShimmerBox(
                  width: 110,
                  height: 120,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                )
              else
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: ShimmerBox(
                    width: 74,
                    height: 74,
                    borderRadius: BorderRadius.all(Radius.circular(37)),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(
                        width: double.infinity,
                        height: 16,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      const SizedBox(height: 10),
                      ShimmerBox(
                        width: MediaQuery.sizeOf(context).width * 0.45,
                        height: 12,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      const SizedBox(height: 10),
                      ShimmerBox(
                        width: MediaQuery.sizeOf(context).width * 0.28,
                        height: 12,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MedicalArchiveListShimmer extends StatelessWidget {
  final int itemCount;
  final bool showThumbnail;

  const MedicalArchiveListShimmer({
    super.key,
    this.itemCount = 5,
    this.showThumbnail = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: itemCount,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: MedicalArchiveCardShimmer(showThumbnail: showThumbnail),
      ),
    );
  }
}

/// Skeleton matching archived visit cards.
class VisitCardShimmer extends StatelessWidget {
  const VisitCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: AppShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ShimmerBox(
                    width: double.infinity,
                    height: 18,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 12),
                ShimmerBox(
                  width: 72,
                  height: 22,
                  borderRadius: BorderRadius.circular(20),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ShimmerBox(
              width: MediaQuery.sizeOf(context).width * 0.55,
              height: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 10),
            ShimmerBox(
              width: MediaQuery.sizeOf(context).width * 0.35,
              height: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 10),
            ShimmerBox(
              width: MediaQuery.sizeOf(context).width * 0.28,
              height: 12,
              borderRadius: BorderRadius.circular(6),
            ),
          ],
        ),
      ),
    );
  }
}

class ArchivedVisitsListShimmer extends StatelessWidget {
  final int itemCount;

  const ArchivedVisitsListShimmer({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      itemCount: itemCount,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.only(bottom: 14),
        child: VisitCardShimmer(),
      ),
    );
  }
}

/// Full patient medical page skeleton for view / create / edit.
/// Covers fixed fields (avatar, name, birth date, gender) + dynamic schema fields.
class PatientMedicalFormShimmer extends StatelessWidget {
  final int dynamicFieldCount;
  final bool includeHeader;

  const PatientMedicalFormShimmer({
    super.key,
    this.dynamicFieldCount = 5,
    this.includeHeader = true,
  });

  Widget _labelField(BuildContext context, {double labelWidthFactor = 0.28}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(
          width: MediaQuery.sizeOf(context).width * labelWidthFactor,
          height: 12,
          borderRadius: BorderRadius.circular(6),
        ),
        const SizedBox(height: 8),
        ShimmerBox(
          width: double.infinity,
          height: 52,
          borderRadius: BorderRadius.circular(14),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: AppShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (includeHeader) ...[
              Center(
                child: ShimmerBox(
                  width: w * 0.45,
                  height: 18,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: ShimmerBox(
                  width: w * 0.65,
                  height: 12,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Avatar
            const Center(
              child: ShimmerBox(
                width: 120,
                height: 120,
                borderRadius: BorderRadius.all(Radius.circular(60)),
              ),
            ),
            const SizedBox(height: 28),

            // Patient Name
            _labelField(context, labelWidthFactor: 0.32),
            const SizedBox(height: 18),

            // Birth Date
            _labelField(context, labelWidthFactor: 0.28),
            const SizedBox(height: 18),

            // Gender label + two cards
            ShimmerBox(
              width: w * 0.2,
              height: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ShimmerBox(
                    width: double.infinity,
                    height: 88,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ShimmerBox(
                    width: double.infinity,
                    height: 88,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // Dynamic schema fields from backend
            for (var i = 0; i < dynamicFieldCount; i++) ...[
              _labelField(context),
              const SizedBox(height: 18),
            ],

            const SizedBox(height: 8),
            // Save / Edit button
            ShimmerBox(
              width: double.infinity,
              height: 54,
              borderRadius: BorderRadius.circular(16),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact field-list shimmer (schema-only section).
class PatientFormFieldsShimmer extends StatelessWidget {
  final int fieldCount;

  const PatientFormFieldsShimmer({super.key, this.fieldCount = 5});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < fieldCount; i++) ...[
            ShimmerBox(
              width: MediaQuery.sizeOf(context).width * 0.28,
              height: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 8),
            ShimmerBox(
              width: double.infinity,
              height: 52,
              borderRadius: BorderRadius.circular(14),
            ),
            const SizedBox(height: 18),
          ],
        ],
      ),
    );
  }
}

/// Skeleton matching family member ProfileCard.
class FamilyMemberCardShimmer extends StatelessWidget {
  const FamilyMemberCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: AppShimmer(
        child: Row(
          children: [
            const ShimmerBox(
              width: 60,
              height: 60,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(
                    width: MediaQuery.sizeOf(context).width * 0.4,
                    height: 16,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: 10),
                  ShimmerBox(
                    width: MediaQuery.sizeOf(context).width * 0.22,
                    height: 12,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton matching the home Profile card (avatar + name + actions).
class ProfileHomeCardShimmer extends StatelessWidget {
  const ProfileHomeCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final w = MediaQuery.sizeOf(context).width;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AppShimmer(
        child: Row(
          children: [
            const ShimmerBox(
              width: 68,
              height: 68,
              borderRadius: BorderRadius.all(Radius.circular(34)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(
                    width: w * 0.42,
                    height: 18,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: 10),
                  ShimmerBox(
                    width: w * 0.22,
                    height: 22,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ],
              ),
            ),
            const ShimmerBox(
              width: 28,
              height: 28,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Single invoice card skeleton.
class InvoiceCardShimmer extends StatelessWidget {
  final bool showPatient;

  const InvoiceCardShimmer({super.key, this.showPatient = false});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final w = MediaQuery.sizeOf(context).width;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AppShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBox(
                  width: w * 0.35,
                  height: 12,
                  borderRadius: BorderRadius.circular(6),
                ),
                ShimmerBox(
                  width: 88,
                  height: 22,
                  borderRadius: BorderRadius.circular(20),
                ),
              ],
            ),
            if (showPatient) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const ShimmerBox(
                    width: 36,
                    height: 36,
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  const SizedBox(width: 10),
                  ShimmerBox(
                    width: w * 0.4,
                    height: 14,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            ShimmerBox(
              width: w * 0.5,
              height: 16,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 10),
            ShimmerBox(
              width: w * 0.28,
              height: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ShimmerBox(
                    width: double.infinity,
                    height: 48,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ShimmerBox(
                    width: double.infinity,
                    height: 48,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ShimmerBox(
                    width: double.infinity,
                    height: 48,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Full financial summary page skeleton (summary + filter + invoice cards).
class FinancialPageShimmer extends StatelessWidget {
  final bool showPatientOnCards;

  const FinancialPageShimmer({
    super.key,
    this.showPatientOnCards = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: AppShimmer(
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        AppShimmer(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerBox(
                width: 100,
                height: 22,
                borderRadius: BorderRadius.circular(6),
              ),
              ShimmerBox(
                width: 90,
                height: 20,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < 4; i++)
          InvoiceCardShimmer(showPatient: showPatientOnCards),
      ],
    );
  }
}

/// Invoice details page skeleton (invoice card + payment rows).
class InvoiceDetailsShimmer extends StatelessWidget {
  final bool showPatient;

  const InvoiceDetailsShimmer({super.key, this.showPatient = false});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final w = MediaQuery.sizeOf(context).width;

    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        InvoiceCardShimmer(showPatient: showPatient),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: AppShimmer(
            child: ShimmerBox(
              width: w * 0.55,
              height: 18,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 10, top: 6),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: scheme.shadow.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AppShimmer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerBox(
                          width: w * 0.32,
                          height: 16,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        ShimmerBox(
                          width: 72,
                          height: 26,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ShimmerBox(
                      width: w * 0.28,
                      height: 12,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: ShimmerBox(
                        width: 64,
                        height: 14,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
