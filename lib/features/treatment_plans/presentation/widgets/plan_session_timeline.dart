import 'dart:math' as math;

import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/features/appointments/presentation/utils/appointment_date_format.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_session.dart';
import 'package:dental_app/features/treatment_plans/data/models/treatment_session_status.dart';
import 'package:dental_app/features/treatment_plans/presentation/widgets/session_status_badge.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PlanSessionTimeline extends StatelessWidget {
  final List<PlanSession> sessions;
  final int? highlightedIndex;
  final ValueChanged<PlanSession> onBook;
  final ValueChanged<PlanSession> onRate;
  final ValueChanged<PlanSession> onOpen;

  const PlanSessionTimeline({
    super.key,
    required this.sessions,
    required this.highlightedIndex,
    required this.onBook,
    required this.onRate,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < sessions.length; i++)
          _SessionTimelineTile(
            session: sessions[i],
            isLast: i == sessions.length - 1,
            highlighted: highlightedIndex == i,
            onBook: onBook,
            onRate: onRate,
            onOpen: onOpen,
          ),
      ],
    );
  }
}

class _SessionTimelineTile extends StatelessWidget {
  final PlanSession session;
  final bool isLast;
  final bool highlighted;
  final ValueChanged<PlanSession> onBook;
  final ValueChanged<PlanSession> onRate;
  final ValueChanged<PlanSession> onOpen;

  const _SessionTimelineTile({
    required this.session,
    required this.isLast,
    required this.highlighted,
    required this.onBook,
    required this.onRate,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final faded = session.isLockedPending ||
        session.status == TreatmentSessionStatus.cancelled;

    return Opacity(
      opacity: faded ? 0.55 : 1,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RailMarker(
              session: session,
              highlighted: highlighted,
              isLast: isLast,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
                child: _SessionCard(
                  session: session,
                  highlighted: highlighted,
                  onBook: onBook,
                  onRate: onRate,
                  onOpen: onOpen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RailMarker extends StatelessWidget {
  final PlanSession session;
  final bool highlighted;
  final bool isLast;

  const _RailMarker({
    required this.session,
    required this.highlighted,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final style = _markerStyle(colors);

    return SizedBox(
      width: 32,
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: style.background,
              shape: BoxShape.circle,
              border: Border.all(color: style.border, width: 1.5),
            ),
            child: Center(child: style.child),
          ),
          if (!isLast)
            Expanded(
              child: CustomPaint(
                painter: _DashedLinePainter(
                  color: colors.outline.withOpacity(0.35),
                ),
                child: const SizedBox(width: 32),
              ),
            ),
        ],
      ),
    );
  }

  _MarkerStyle _markerStyle(ColorScheme colors) {
    switch (session.status) {
      case TreatmentSessionStatus.completed:
        return _MarkerStyle(
          background: colors.primary,
          border: colors.primary,
          child: const Icon(Icons.check, size: 16, color: Colors.white),
        );
      case TreatmentSessionStatus.pending:
        if (session.canBook || highlighted) {
          return _MarkerStyle(
            background: colors.secondary,
            border: colors.secondary,
            child: const Icon(
              Icons.calendar_month_rounded,
              size: 16,
              color: Colors.white,
            ),
          );
        }
        return _MarkerStyle(
          background: colors.surface,
          border: colors.outline.withOpacity(0.45),
          child: Text(
            '${session.sessionOrder}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: colors.onSurface.withOpacity(0.45),
            ),
          ),
        );
      case TreatmentSessionStatus.booked:
      case TreatmentSessionStatus.inTreatment:
        return _MarkerStyle(
          background: colors.primary.withOpacity(0.12),
          border: colors.primary,
          child: Icon(
            Icons.event_available_outlined,
            size: 16,
            color: colors.primary,
          ),
        );
      case TreatmentSessionStatus.cancelled:
        return _MarkerStyle(
          background: colors.surface,
          border: colors.outline.withOpacity(0.4),
          child: Icon(
            Icons.close_rounded,
            size: 16,
            color: colors.onSurface.withOpacity(0.4),
          ),
        );
    }
  }
}

class _MarkerStyle {
  final Color background;
  final Color border;
  final Widget child;

  const _MarkerStyle({
    required this.background,
    required this.border,
    required this.child,
  });
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const dash = 4.0;
    const gap = 3.5;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    var y = 4.0;
    final x = size.width / 2;
    while (y < size.height) {
      final end = math.min(y + dash, size.height);
      canvas.drawLine(Offset(x, y), Offset(x, end), paint);
      y += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _SessionCard extends StatelessWidget {
  final PlanSession session;
  final bool highlighted;
  final ValueChanged<PlanSession> onBook;
  final ValueChanged<PlanSession> onRate;
  final ValueChanged<PlanSession> onOpen;

  const _SessionCard({
    required this.session,
    required this.highlighted,
    required this.onBook,
    required this.onRate,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = session.title.isEmpty
        ? '${'Session'.tr()} ${session.sessionOrder}'
        : session.title;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => onOpen(session),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: highlighted
                ? Border.all(color: colors.primary.withOpacity(0.55), width: 1.4)
                : Border.all(color: colors.outline.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withOpacity(isDark ? 0.22 : 0.07),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: SessionStatusBadge(session: session),
                    ),
                  ),
                  if (session.completedAt != null)
                    Text(
                      formatAppointmentDate(session.completedAt!),
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: colors.onSurface.withOpacity(0.55),
                      ),
                    ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 14,
                    color: colors.onSurface.withOpacity(0.35),
                  ),
                ],
              ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
              height: 1.35,
            ),
          ),
          if (_metaLine(session) != null) ...[
            const SizedBox(height: 6),
            Text(
              _metaLine(session)!,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: colors.onSurface.withOpacity(0.55),
              ),
            ),
          ],
          if (session.isLockedPending) ...[
            const SizedBox(height: 8),
            Text(
              'Complete the previous session first.'.tr(),
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: colors.onSurface.withOpacity(0.55),
              ),
            ),
          ],
          if (session.rating != null && session.rating! > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: index < session.rating!
                      ? AppColors.accent
                      : colors.outline.withOpacity(0.35),
                );
              }),
            ),
          ],
          if (session.isBookablePending) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => onBook(session),
                icon: const Icon(Icons.calendar_month_rounded, size: 18),
                label: Text('Book this session now'.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
          if (session.pendingRatingEnabled) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => onRate(session),
                icon: const Icon(Icons.star_outline_rounded, size: 18),
                label: Text('Rate your visit'.tr()),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.primary,
                  side: BorderSide(color: colors.primary.withOpacity(0.3)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
            ],
          ),
        ),
      ),
    );
  }

  String? _metaLine(PlanSession session) {
    final parts = <String>[];
    if (session.durationMinutes != null && session.durationMinutes! > 0) {
      parts.add('${session.durationMinutes} ${'min'.tr()}');
    }
    if (session.isBookablePending &&
        session.estimatedCost != null &&
        session.estimatedCost!.trim().isNotEmpty) {
      parts.add(
        '${'Estimated cost'.tr()}: ${session.estimatedCost}',
      );
    }
    final availableAt = session.availableForBookingAt;
    if (session.isBookablePending && availableAt != null) {
      final now = DateTime.now();
      final day = DateTime(availableAt.year, availableAt.month, availableAt.day);
      final today = DateTime(now.year, now.month, now.day);
      if (day.isAfter(today)) {
        parts.add(
          '${'Available from'.tr()} ${formatAppointmentDate(availableAt)}',
        );
      }
    }
    if (parts.isEmpty) return null;
    return parts.join(' • ');
  }
}
