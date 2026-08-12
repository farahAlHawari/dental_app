import 'package:dental_app/features/appointments/data/models/bookable_session.dart';
import 'package:dental_app/features/appointments/presentation/utils/appointment_date_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BookableSessionCard extends StatelessWidget {
  final BookableSession session;
  final VoidCallback? onBook;

  const BookableSessionCard({
    super.key,
    required this.session,
    this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final canBook = session.canBook && onBook != null;

    return Opacity(
      opacity: canBook ? 1 : 0.72,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: canBook
              ? null
              : Border.all(color: colors.outline.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withOpacity(isDark ? 0.30 : 0.10),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                if (session.planName.isNotEmpty)
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.folder_outlined,
                              size: 13,
                              color: colors.primary,
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                session.planName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: colors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (session.sessionOrder > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colors.secondary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${'Session'.tr()} ${session.sessionOrder}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: colors.secondary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              session.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            if (_metaItems(session).isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _metaItems(session)
                    .map(
                      (item) => _MetaChip(
                        icon: item.icon,
                        label: item.label,
                      ),
                    )
                    .toList(),
              ),
            ],
            if (!canBook) ...[
              const SizedBox(height: 10),
              Text(
                'Complete the previous session in this plan before booking this one.'
                    .tr(),
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: colors.onSurface.withOpacity(0.55),
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canBook ? onBook : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  disabledBackgroundColor: colors.onSurface.withOpacity(0.08),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  canBook
                      ? 'Select this session'.tr()
                      : 'Not ready to book yet'.tr(),
                  style: TextStyle(
                    color: canBook
                        ? Colors.white
                        : colors.onSurface.withOpacity(0.4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_MetaItem> _metaItems(BookableSession session) {
    final items = <_MetaItem>[];

    if (session.durationMinutes != null && session.durationMinutes! > 0) {
      items.add(
        _MetaItem(
          icon: Icons.schedule_rounded,
          label: '${session.durationMinutes} ${'min'.tr()}',
        ),
      );
    }

    if (session.estimatedCost != null && session.estimatedCost!.isNotEmpty) {
      items.add(
        _MetaItem(
          icon: Icons.payments_outlined,
          label: '${'Estimated cost'.tr()}: ${session.estimatedCost}',
        ),
      );
    }

    final availableAt = session.availableForBookingAt;
    if (availableAt != null) {
      final now = DateTime.now();
      final day = DateTime(availableAt.year, availableAt.month, availableAt.day);
      final today = DateTime(now.year, now.month, now.day);
      if (day.isAfter(today)) {
        items.add(
          _MetaItem(
            icon: Icons.event_available_outlined,
            label:
                '${'Available from'.tr()} ${formatAppointmentDate(availableAt)}',
          ),
        );
      }
    }

    return items;
  }
}

class _MetaItem {
  final IconData icon;
  final String label;

  const _MetaItem({required this.icon, required this.label});
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outline.withOpacity(0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.onSurface.withOpacity(0.55)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: colors.onSurface.withOpacity(0.75),
            ),
          ),
        ],
      ),
    );
  }
}
